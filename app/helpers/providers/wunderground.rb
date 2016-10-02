require 'nokogiri'
require 'extraction'
require 'fetcher'
require 'json'

class ProviderWunderground
  attr_accessor :fetcher
  def initialize()
  end

  def search(search)
    url = "http://autocomplete.wunderground.com/aq?cb=jQuery17208999886005185544_1389477403791&query=#{search}&h=1&ski=1&features=1"
    content = @fetcher.getUrl(url)
    return_value = Array.new
    if data = /.*?\((.*)\);/m.match(content)
      results = JSON.parse(data[1])
      results = results['RESULTS']
      results.each do |it|
        return_value.push Location.new(:token => it['l'], :name => it['name'])
      end
    end
    return_value
  end

  def fetch(forecast_id)
    url = "http://www.wunderground.com/#{forecast_id}"
    content = @fetcher.getUrl(url)
    m = /.*<script>\s*wui.bootstrapped.API\s*=\s*(.*?);\s*<\/script>/m.match(content)
    if m == nil
      return []
    end

    returnValue = Array.new

    data = JSON.parse(m[1].strip!)
    data['forecast']['days'].each do |day|
      summary = day['summary']
      date = Time.at(summary['date']['epoch'])
      midnight = DateTime.new(date.year, date.month, date.day)

      forecast_day = Forecast.new
      forecast_day.daytime = 'Day'
      forecast_day.date = midnight
      forecast_day.summary = summary['day']['condition']
      forecast_day.temp_min = summary['low']
      forecast_day.temp_max = summary['high']
      forecast_day.wind_speed = summary['wind_avg_speed']
      forecast_day.wind_dir = summary['wind_avg_dir']
      returnValue.push forecast_day
    
      forecast_night = Forecast.new
      forecast_night.daytime = 'Night'
      forecast_night.date = midnight
      forecast_night.summary = summary['day']['condition']
      forecast_night.temp_min = summary['low']
      forecast_night.temp_max = summary['high']
      forecast_night.wind_speed = summary['wind_avg_speed']
      forecast_night.wind_dir = summary['wind_avg_dir']
      returnValue.push forecast_night
       
    end


    returnValue
  end
end

