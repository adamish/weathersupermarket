require 'nokogiri'
require 'extraction'
require 'fetcher'

class ProviderMetoffice
  attr_accessor :fetcher
  def initialize()
    @url="<your API key here>";

    @codes = Hash.new
    @codes['0']='Clear night'
    @codes['1']='Sunny day'
    @codes['2']='Partly cloudy'
    @codes['3']='Partly cloudy'
    @codes['4']='Not used'
    @codes['5']='Mist'
    @codes['6']='Fog'
    @codes['7']='Cloudy'
    @codes['8']='Overcast'
    @codes['9']='Light rain shower'
    @codes['10']='Light rain shower'
    @codes['11']='Drizzle'
    @codes['12']='Light rain'
    @codes['13']='Heavy rain shower'
    @codes['14']='Heavy rain shower'
    @codes['15']='Heavy rain'
    @codes['16']='Sleet shower'
    @codes['17']='Sleet shower'
    @codes['18']='Sleet'
    @codes['19']='Hail shower'
    @codes['20']='Hail shower'
    @codes['21']='Hail'
    @codes['22']='Light snow shower'
    @codes['23']='Light snow shower'
    @codes['24']='Light snow'
    @codes['25']='Heavy snow shower'
    @codes['26']='Heavy snow shower'
    @codes['27']='Heavy snow'
    @codes['28']='Thunder shower'
    @codes['29']='Thunder shower'
    @codes['30']='Thunder'
  end

  def search(search)
    # locations already available in "5,000" feed
    return_value = Array.new

    MetofficeLocation.where('name_lower LIKE ?', "%#{search}%").each do |it|
      return_value.push Location.new(:token => it.token, :name => it.name)
    end
    return_value
  end

  def build_site_list
    if MetofficeLocation.count  > 10
      puts "Already imported. Returning"
      return
    end
    
    #url = "http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/json/sitelist?key=#{@url}"
    url = 'data/metoffice-sitelist.json'
    content = @fetcher.getUrl(url)
    #content = File.read('data/metoffice-sitelist.json')
    result = JSON.parse(content)
    ActiveRecord::Base.transaction do
      result['Locations']['Location'].each do |location|
        MetofficeLocation.create(:token => location['id'], :name => location['name'],:name_lower => location['name'].downcase)
      end
    end
  end

  def fetch(forecast_id)
    url = "http://datapoint.metoffice.gov.uk/public/data/val/wxfcs/all/json/#{forecast_id}?res=3hourly&key=#{@url}"
    content = @fetcher.getUrl(url)
    result = JSON.parse(content)
    returnValue = Array.new
    days=result['SiteRep']['DV']['Location']['Period']
    days.each do |day|
      date_start = DateTime.parse(day['value'])
      already_gone = 8 - day['Rep'].count
      date = date_start.advance(:hours => (3 * already_gone))

      day['Rep'].each do |period|
        forecast = Forecast.new
        forecast.date = date_start
        forecast.daytime = date.strftime("%H:%M")
        forecast.summary = @codes[period['W']]
        forecast.temp_max = period['T'].to_i
        forecast.temp_min = period['T'].to_i
        forecast.wind_speed = period['S'].to_f * 1.0/0.621371
        forecast.wind_dir = period['D']
        forecast.link = ''
        returnValue.push(forecast)
        date = date.advance(:hours => 3)

      end
    end
    returnValue
  end
end

