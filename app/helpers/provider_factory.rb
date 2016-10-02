require 'providers/accuweather'
require 'providers/bbc'
require 'providers/metcheck'
require 'providers/metoffice'
require 'providers/weatherchannel'
require 'providers/wunderground'

class ProviderFactory
  @@cache = Hash.new
  def getProvider(name)
    return_value = @@cache[name]
    if return_value == nil
      case name
      when 'accuweather'
        return_value = ProviderAccuweather.new
      when 'weatherchannel'
        return_value = ProviderWeatherChannel.new
      when 'weatherunderground'
        return_value = ProviderWunderground.new
      when 'metoffice'
        return_value = ProviderMetoffice.new
      when 'metcheck'
        return_value = ProviderMetcheck.new
      when 'bbc'
        return_value = ProviderBbc.new
      end
      return_value.fetcher = Fetcher.new

      @@cache[name] = return_value
    end
    return_value
  end
end
