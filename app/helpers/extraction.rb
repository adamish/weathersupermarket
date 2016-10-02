require 'time_service'

class Extraction
  def Extraction.temperature(content)
    returnValue = content
    if data = /(-?\d+)/.match(content.strip)
      returnValue = data[1]
    end
    returnValue.to_i
  end

  def Extraction.wind(content)
    returnValue = content
    if data = /(\d+)/.match(content.strip)
      returnValue = data[1].to_i
    end
    returnValue
  end

  # Sep 1, Oct 31
  def Extraction.date_a(content)
    parsed_date = DateTime.parse(content)
    now = TimeService.now
    dates = [ parsed_date, parsed_date.next_year, parsed_date.prev_year ]
    dates.min_by { |d| (d.to_time.to_i - now.to_time.to_i).abs }
  end

  # Monday, 13
  def Extraction.date_b(content)
    now = TimeService.now
    data = /(.*),\s*(\d+)/.match(content)
    candidate = DateTime.new(now.year, now.month, data[2].to_i)
    dates = [ candidate, candidate.next_month, candidate.prev_month ]
    dates.min_by { |d| (d.to_time.to_i - now.to_time.to_i).abs }
  end

  def Extraction.date_b_relative(content, now)
    data = /(.*),\s*(\d+)/.match(content)
    candidate = DateTime.new(now.year, now.month, data[2].to_i)
    dates = [ candidate, candidate.next_month, candidate.prev_month ]
    dates.min_by { |d| (d.to_time.to_i - now.to_time.to_i).abs }
  end
end

