require 'nokogiri'
require 'extraction'
require 'fetcher'

class ProviderMetcheck
  attr_accessor :fetcher
  def search(search)
    url = "http://www.metcheck.com/WEBSERVICES/API/LOCATIONS/json.asp?name_startsWith=#{search}"
    content = @fetcher.getUrl(url)
    elements = JSON.parse(content)
    elements = elements['geonames']
    locations = Array.new
    elements.each do |it|
      locationId = it['locationID']
      if locationId != 0
        name = it['name'] + ", " + it['countryCode']
        if it['adminName1'].length > 0
          name = name + ", " + it['adminName1']
        end
        locations.push(Location.new(:token => locationId.to_s, :name => name))
      end
    end
    locations
  end

  def fetch(forecast_id)
    url = "http://www.metcheck.com/UK/7days.asp?zipcode=foo&locationID=#{forecast_id}"
    content = @fetcher.getUrl(url)

    doc = Nokogiri::HTML(content)
    returnValue = Array.new

    dates = Array.new
    doc.css('td.dataTableDayRow').each do |it|
      dates.push Extraction.date_a(it.text.strip)
    end
    date_count = 0

    times_of_day = ['Morning', 'Afternoon', 'Evening']
    doc.css('tr[valign="middle"]').each do |it|
      top_row = it.css('td.dataTableTopRow')
      time_of_day = top_row.text.strip
      if times_of_day.include? time_of_day
        cols = it.css('td.dataTableDataRow')
        icon_cols = it.css('td.dataTableIconRow img')
        if time_of_day == 'Morning'
          wind_col = cols[5]
          temp_col = cols[0]
        else
          wind_col = cols[6]
          temp_col = cols[1]
        end

        temp = Extraction.temperature(temp_col.text)
        wind_speed = Extraction.temperature(wind_col.text)

        wind_col = it.css('td.dataTableDataRow img')
        wind_dir = wind_col.attribute('title').text.match(/.*Wind from\s+(.*?)\s+.*/i)[1]

        forecast = Forecast.new
        forecast.date = dates[date_count]
        forecast.daytime = time_of_day
        forecast.summary = icon_cols.attr('title').text.strip
        forecast.temp_max = temp
        forecast.temp_min = temp
        forecast.wind_speed = wind_speed
        forecast.wind_dir = wind_dir
        returnValue.push forecast
        if time_of_day == 'Evening'
          date_count = date_count + 1
        end
      end
    end

    returnValue
  end
end

