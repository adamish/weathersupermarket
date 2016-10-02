require 'spec_helper'
require 'providers/weatherchannel'

module Wsm
  describe Wsm do

    describe ProviderWeatherChannel, "#search" do
      it "search" do
        content = IO.read("test/resources/weatherchannel/location-search-york.jsonp")
        provider = ProviderWeatherChannel.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.search('york')
        assert_equal(20, result.count)
        assert_equal('USNY0996', result[0].token)
        assert_equal('New York, NY, US', result[0].name)
      end
    end
    describe ProviderWeatherChannel, "#extract" do
      it "extract" do
        content = IO.read("test/resources/weatherchannel/new-york.html")
        provider = ProviderWeatherChannel.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.fetch(123)
        assert_equal(10, result.length)

        assert_equal(-1, result[0].temp_min)
        assert_equal(3,  result[1].temp_min)
        assert_equal(5,  result[2].temp_min)
                
        assert_equal(10, result[0].temp_max)
        assert_equal(9,  result[1].temp_max)
        assert_equal(12, result[2].temp_max)        

        assert_equal(DateTime.new(2014, 11, 3), result[0].date)
        assert_equal(DateTime.new(2014, 11, 4), result[1].date)
        assert_equal(DateTime.new(2014, 11, 5), result[2].date)   
        
        assert_equal(24, result[0].wind_speed)
        assert_equal(17, result[1].wind_speed)
        
        assert_equal('N', result[0].wind_dir)
        assert_equal('NNE', result[1].wind_dir)
        assert_equal('E', result[2].wind_dir)
        
      end
    end
  end
end