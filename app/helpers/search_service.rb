require 'request_proxy'

class SearchService
  @@instance = nil
  @@providers = Provider.all
  @@factory = ProviderFactory.new
  def self.instance
    if @@instance == nil
      @@instance = RequestProxy.new(SearchService.new)
    end
    @@instance
  end

  def request(search_str)
    locations = nil
    results = Search.where("search = ?", search_str).includes(:locations)
    if results.count == 1
      locations = results[0].locations
    else
      locations = self.scrape(search_str)
      self.save(search_str, locations)
    end
    locations
  end

  def scrape(search_str)
    locations = Array.new
    mutex = Mutex.new
    threads = Array.new
    self.get_all_providers.each do |p|
      thread = Thread.new do
        matches = @@factory.getProvider(p.name).search(search_str)
        matches.each do |match|
          match.provider = p
        end
        ActiveRecord::Base.connection_pool.release_connection
        mutex.synchronize do
          locations.concat(matches)
        end
      end
      threads.push(thread)
    end
    threads.each { |it| it.join }

    locations
  end

  def get_all_providers
    @@providers
  end

  def save(search_str, locations)
    ActiveRecord::Base.transaction do

      search = Search.where("search = ?", search_str)
      if search.count == 0
        search = Search.create(search: search_str)
      else
        search = search[0]
      end

      locations.each do |location|
        existing = Location.where("provider_id = ? AND token = ?", location.provider.id,  location.token)
        if (existing.count == 0)
          location.save
          existing = location
        else
          existing = existing[0]
          location.id = existing.id
        end
        SearchResult.create(location: existing, search: search)
      end
    end
  end
end
