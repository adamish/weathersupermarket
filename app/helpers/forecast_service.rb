class ForecastService
  @@factory = ProviderFactory.new
  def initialize
    @service = RequestProxy.new(self)
  end

  def save(new_forecasts, location)
    ActiveRecord::Base.transaction do
      sql = "DELETE FROM forecasts WHERE location_id = #{location.id}"
      Forecast.connection.execute(sql)
      new_forecasts.each do |it|
        it.save
      end
      location.update(last_fetch: DateTime.now)
    end
  end

  def needs_update?(location)
    max_age = 60 * 60 * 1.5
    if location.last_fetch == nil
      return true
    else
      age = DateTime.now.to_i - location.last_fetch.to_i
    end
    age > max_age
  end

  # could be 1,2,3 etc.
  def fetch(locations)
    return_value = Array.new

    update_locations = Array.new
    locations.each do |location|
      if self.needs_update? location
        update_locations.push(location)
      else
        return_value.push(self.get_latest(location))
      end
    end

    threads = Array.new
    mutex = Mutex.new
    new_values = Array.new
    update_locations.each do |location|
      thread = Thread.new do
        result = @service.request(location)
        ActiveRecord::Base.connection_pool.release_connection
        mutex.synchronize do
          new_values.push(result)
        end
      end
      threads.push(thread)
    end

    threads.each { |it| it.join }

    new_values.each do |it|
      self.save(it[:results], it[:location])
    end
    return_value = return_value.concat new_values

    return_value.each do |it|
      it[:location] = it[:location].id
    end
    return_value
  end

  def request(location)
    t0 = (Time.now.to_f * 1000).to_i

    forecasts = Array.new
    provider = @@factory.getProvider(location.provider.name)

    begin
      forecasts = provider.fetch(location.token)
      forecasts.each do |it|
        data = StarRating.process(it)
        it.stars = data[0]
        it.symbol = data[1]
        it.location_id = location.id
      end
    rescue Exception => e
      Rails.logger.error "Error fetching #{location} #{e}"
    end
    t1 = (Time.now.to_f * 1000).to_i

    Rails.logger.info "ForecastService: #{location} #{(t1 -t0).round} ms"
    {provider: location.provider.name,location: location,locationName: location.name,results: forecasts}
  end

  def get_latest(location)
    now = DateTime.now
    midnight = DateTime.new(now.year, now.month, now.day)
    forecasts = Forecast.where('location_id = :location AND date >= :window', {
      window: midnight,
      location: location.id
    });
    {provider: location.provider.name,location: location,locationName: location.name,results: forecasts}

  end

end
