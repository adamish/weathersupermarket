require 'spec_helper'
require 'providers/wunderground'

module Wsm
  describe Wsm do

    describe ProviderWunderground, "#search" do
      it "search" do
        content = IO.read("test/resources/wunderground/location-search-stockport.json")
        provider = ProviderWunderground.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.search('dummy')
        assert_equal(result.count, 2)
        assert_equal('/q/zmw:00000.1.02485', result[0].token)
        assert_equal('Stockholm, Sweden', result[0].name)
      end
    end

    describe ProviderWunderground, "#extract" do
      it "extract" do
        content = IO.read("test/resources/wunderground/stockport.html")
        provider = ProviderWunderground.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.fetch(123)
        assert_equal(20, result.count)
        assert_equal('Chance of rain'.downcase, result[0].summary.downcase)
        assert_equal([2, 2, 1], result.collect {|x| x.temp_min}.slice(0, 3))
        assert_equal([11, 11, 14], result.collect {|x| x.temp_max}.slice(0, 3))

        assert_equal([27, 27, 11], result.collect {|x| x.wind_speed}.slice(0, 3))
        assert_equal(['W', 'W', 'NE'], result.collect {|x| x.wind_dir}.slice(0, 3))

        assert_equal(DateTime.new(2014, 4, 17), result[0].date)
        assert_equal(DateTime.new(2014, 4, 20), result[7].date)
      end
    end
  end
end