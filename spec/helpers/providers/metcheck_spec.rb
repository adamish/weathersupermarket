require 'spec_helper'
require 'providers/metcheck'

module Wsm
  describe Wsm do

    describe ProviderMetcheck, "#search" do
      it "search" do
        content = IO.read("test/resources/metcheck/location-search-stockport.json")
        provider = ProviderMetcheck.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.search('stockport')
        assert_equal(1, result.count)
        assert_equal("Stockport, United Kingdom", result[0].name)
        assert_equal("56831", result[0].token)
      end
    end

    describe ProviderMetcheck, "#extract" do
      it "extract" do
        content = IO.read("test/resources/metcheck/forecast-stockport.html")
        provider = ProviderMetcheck.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.fetch(123)
        assert_equal(23, result.count)
        assert_equal(6, result[0].temp_min)
        assert_equal(9, result[1].temp_min)
        assert_equal(2, result[2].temp_min)

        assert_equal(6, result[0].temp_max)
        assert_equal(9, result[1].temp_max)
        assert_equal(2, result[2].temp_max)

        assert_equal(DateTime.new(2013, 12, 1), result[0].date)
        assert_equal(DateTime.new(2013, 12, 1), result[1].date)
        assert_equal(DateTime.new(2013, 12, 1), result[2].date)

        assert_equal(6, result[0].wind_speed)
        assert_equal(3, result[1].wind_speed)
        assert_equal(3, result[2].wind_speed)

        assert_equal('NW', result[0].wind_dir)
        assert_equal('NNE', result[1].wind_dir)
        assert_equal('SE', result[2].wind_dir)

        assert_equal('Mainly Clear', result[0].summary)
        assert_equal('Fair', result[1].summary)
        assert_equal('Mist or Fog', result[2].summary)
      end
    end
  end
end