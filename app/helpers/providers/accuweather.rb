require 'nokogiri'
require 'extraction'
require 'fetcher'

class ProviderAccuweather
  attr_accessor :fetcher
  def search(search)
    url = "http://www.accuweather.com/ajax-service/popular-cities?q=#{search}&lid=1"
    content = @fetcher.getUrl(url)

    locations = Array.new
    content.each_line do |line|
      m = /(.*)\|(.*)/.match(line)
      locations.push(Location.new(:token => m[2], :name => m[1]))
    end
    locations
  end

  def fetch(forecast_id)
    url = "http://www.accuweather.com/en/gb/manchester/m1-2/daily-weather-forecast/#{forecast_id}"
    content = @fetcher.getUrl(url, "acm=__utmli=settings-temp-unit-celsius")
    doc = Nokogiri::HTML(content)

    returnValue = Array.new
    doc.css('#feed-tabs li.day div.bg').each do |it|
      forecast = Forecast.new
      forecast.date = Extraction.date_a(it.css('h4').text.strip)
      forecast.daytime = 'day'
      forecast.summary = it.css('span.cond').text.strip
      forecast.temp_max = Extraction.temperature(it.css('div.info strong.temp').text)
      forecast.temp_min = Extraction.temperature(it.css('div.info span.low').text)
      forecast.wind_speed = nil
      forecast.wind_dir = nil
      forecast.link = url
      returnValue.push forecast
    end
    returnValue
  end
end

