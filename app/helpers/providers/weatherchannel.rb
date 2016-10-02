require 'nokogiri'
require 'extraction'
require 'fetcher'

class ProviderWeatherChannel
  attr_accessor :fetcher
  def initialize()
  end

  def search(search)
    url = "http://wxdata.weather.com/wxdata/ta/#{search}.js?locType=1,5,9,11,13,19,25&cb=twctacb_181838877_4&key=2227ef4c-dfa4-11e0-80d5-0022198344f4&max=20&locale=en_GB&countrySort=UK"
    content = @fetcher.getUrl(url)

    return_value = Array.new
    if data = /.*?\((.*)\)/m.match(content)
      results = JSON.parse(data[1])
      results = results['results']
      results.each do |it|
        return_value.push Location.new(:token => it['key'], :name => "#{it['name']}, #{it['state']}, #{it['country']}")
      end
    end
    return_value
  end

  def fetch(forecast_id)
    url = "http://uk.weather.com/weather/10day-#{forecast_id}"
    content = @fetcher.getUrl(url)

    returnValue = Array.new
    doc = Nokogiri::HTML(content)
    doc.css('#wx-centerbody-container-10day').css('.wx-daypart').each do |it|
      forecast = Forecast.new
      forecast.date = Extraction.date_a(it.css("h3 span.wx-label").text)
      forecast.daytime = it.css('td.dayname').text.strip
      forecast.summary = it.css('p.wx-phrase').text.strip
      forecast.temp_max = Extraction.temperature(it.css('p.wx-temp').text)
      forecast.temp_min = Extraction.temperature(it.css('p.wx-temp-alt').text)
      wind_line = it.css("div.wx-details dl")[1].css("dd").text.strip
      wind_details = /(.*)\s+at (\d+) mph/.match(wind_line)
      forecast.wind_speed = Extraction.wind(wind_details[2]) * 1.0/0.621371
      forecast.wind_dir = wind_details[1]
      returnValue.push forecast

    end

    returnValue
  end
end

