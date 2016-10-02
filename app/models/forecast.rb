class Forecast < ActiveRecord::Base
  def to_s
    "#{date} #{temp_min} #{temp_max} #{summary}"
  end
  
  def as_json(options={})
    {
      date: self.date.to_i,
      daytime: self.daytime,
      min: self.temp_min,
      max: self.temp_max,
      summary: self.summary,
      location: self.location_id,
      stars: self.stars,
      link: self.link,
      symbol: self.symbol,
      windSpeed: self.wind_speed,
      windDir: self.wind_dir
    }
  end
end
