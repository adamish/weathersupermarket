require 'spec_helper'
require 'providers/accuweather'

module Wsm
  describe Wsm do

    describe ProviderAccuweather, "#search" do
      it 'returns search results' do
        content = IO.read("test/resources/accuweather/location-search-york.raw")
        provider = ProviderAccuweather.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.search('dummy')
        assert_equal(result.count, 6)
        assert_equal('331608', result[0].token)
        assert_equal('York, ENG-YOR GB', result[0].name)
      end
    end

    describe ProviderAccuweather, "#extract" do
      it 'extracts forecasts' do
        content = IO.read("test/resources/accuweather/york.html")
        provider = ProviderAccuweather.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.fetch(123)
        assert_equal(4, result.count)
        assert_equal('Periods of rain', result[0].summary)
        assert_equal([10, 5, 7, 7], result.collect {|x| x.temp_min})
        assert_equal([13, 14, 12, 13], result.collect {|x| x.temp_max})
        assert_equal(DateTime.new(2014, 4, 25), result[0].date)
      end
    end
  end
end