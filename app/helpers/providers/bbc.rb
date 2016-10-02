require 'nokogiri'
require 'extraction'
require 'fetcher'

class ProviderBbc
  attr_accessor :fetcher
  def search(search)
    url = "http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?search=#{search}&filter=international"
    content = @fetcher.getUrl(url)
    elements = JSON.parse(content)
    locations = Array.new
    elements.each do |it|
      locations.push(Location.new(:token => it['id'], :name => it['fullName']))
    end
    locations
  end

  def fetch(forecast_id)
    url = "http://www.bbc.co.uk/weather/#{forecast_id}"
    content = @fetcher.getUrl(url)
    doc = Nokogiri::HTML(content)

    dates = Array.new
    doc.css('ul.daily li').each do |it|
      m = /day-(\d+{4})(\d+{2})(\d+{2})\s+.*/.match(it.attr('class'))
      dates.push(DateTime.new(m[1].to_i,m[2].to_i,m[3].to_i))
    end

    returnValue = Array.new
    i = 0
    doc.css('#forecast-data-table tr.day').each do |it|
      forecast = Forecast.new
      forecast.date = dates[i]
      forecast.daytime = it.css('td.dayname').text.strip
      forecast.summary = it.css('td.weather').text.strip
      forecast.temp_max = Extraction.temperature(it.css('td.max-temp span.temperature-value-unit-c').text)
      forecast.temp_min = Extraction.temperature(it.css('td.min-temp span.temperature-value-unit-c').text)
      forecast.wind_speed = Extraction.wind(it.css('td.wind span.windspeed-value-unit-kph').text)
      forecast.wind_dir = Extraction.wind(it.css('td.wind span.wind-direction').text)
      forecast.link = url
      returnValue.push forecast
      i = i + 1
    end
    returnValue
  end
end

