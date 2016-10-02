class StarRating
  # Calculate a logical forecast from a summary text
  # @param summary Summary, something like "Light rain, sunny intervals"
  # @return array with following attributes
  # 'sun'
  # :rain => 0,1,2
  # 'cloud'
  # 'snow'
  # 'fog'
  # 'thunder'
  def self.get_logical(summaryOriginal)
    rv=Hash.new
    summary = summaryOriginal.downcase
    if /light rain/.match(summary) ||
    /drizzle/.match(summary) ||
    /chance.*shower/.match(summary)
      rv[:rain]=1
    elsif /heavy rain/.match(summary)
      rv[:rain]=2
    elsif /rain/.match(summary) ||
    /shower/.match(summary)
      rv[:rain]=1
    end

    if /(mostly|mainly|partly) sunny/.match(summary) ||
    /some sun/.match(summary) ||
    /sunny intervals/.match(summary)
      rv[:sun]=1
      rv[:cloud]=1
    elsif /sunny/.match(summary) ||
    /fair/.match(summary) ||
    /sun/.match(summary)
      rv[:sun]=1
    end

    if /thunder|t-storm/.match(summary)
      rv[:thunder]=1
    end

    if /fog/.match(summary)
      rv[:fog]=1
    end

    if /(mostly|clear) clear/.match(summary)
      rv[:sun]=1
      rv[:cloud]=1
    elsif /clear/.match(summary)
      rv[:sun]=1
    end

    if /snow|sleet/.match(summary)
      rv[:snow]=1
    end

    if /(mostly|partly) cloudy/.match(summary)
      rv[:sun]=1
      rv[:cloud]=1
    elsif /cloud/.match(summary)
      rv[:cloud]=1
    end

    rv
  end

  def self.process(forecast)
    points=0
    max = forecast.temp_max
    if (max >= 30)
      points=5
    elsif (max >= 24 && max <30)
      points=4
    elsif (max >= 18 && max <24)
      points=3
    elsif (max >= 10 && max <18)
      points=2
    else (max <=9)
      points=1
    end

    log = self.get_logical(forecast.summary)

    if (log[:rain] && log[:rain] == 1)
      points-=0.5
    end
    if (log[:rain] && log[:rain] == 1)
      points-=1
    end
    if (log[:thunder])
      points-=1
    end
    if (log[:cloud])
      points-=1
    end

    if (log[:sun])
      points+=2
    end

    if (points > 5)
      points=5
    elsif(points < 1)
      points=1
    end
    [points, self.get_symbol(log)]
  end

  def self.get_symbol(log)
    if log.length == 1 && log[:sun]
      rv="sun"
    elsif log.length == 1 && log[:cloud]
      rv="cloud"
    elsif log[:cloud] && log[:sun]
      rv="cloud-sun"
    elsif log[:rain] == 1
        rv="rain1"
    elsif log[:rain] == 2
        rv="rain2"
    elsif log[:snow]
      rv="snow1"
    elsif ([:thunder])
        rv="thunder"
    end
    rv
  end

end
