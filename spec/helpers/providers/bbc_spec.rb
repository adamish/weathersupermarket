require 'spec_helper'
require 'providers/bbc'

module Wsm
  describe Wsm do

    describe ProviderBbc, "#search" do
      it "search" do
        content = IO.read("test/resources/bbc/location-search-man.json")
        provider = ProviderBbc.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.search('york')
        assert_equal(result.count, 10)
        assert_equal(result[0].token, '2284647')
        assert_equal(result[0].name, 'Man, Ivory Coast')
      end
    end

    describe ProviderBbc, "#extract" do
      it "extract" do
        content = IO.read("test/resources/bbc/bbc.html")
        provider = ProviderBbc.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.fetch(123)
        assert_equal(5, result.count)
        assert_equal('Light Rain', result[0].summary)
        assert_equal(13, result[0].temp_min)
        assert_equal(19, result[0].temp_max)
        assert_equal(DateTime.new(2013, 9, 12), result[0].date)
      end
    end
  end
end