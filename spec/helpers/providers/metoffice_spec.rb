require 'spec_helper'
require 'providers/metoffice'

module Wsm
  describe Wsm do

    describe ProviderMetoffice, "#build_site_list" do
      it "builds site table" do
        content = IO.read("test/resources/metoffice/site-list.json")
        provider = ProviderMetoffice.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        expect_number = MetofficeLocation.count + 3
        result = provider.build_site_list()
        assert_equal(expect_number, MetofficeLocation.count)
        assert_equal("Rosehearty Samos", MetofficeLocation.where("token = '?'", 3094).first.name)
      end
    end

    describe ProviderMetoffice, "#search" do
      it "search" do
        provider = ProviderMetoffice.new
        result = provider.search('udders')
        assert_equal(1, result.count)
        assert_equal("Huddersfield", result[0].name)
        assert_equal("MET3", result[0].token)
      end
    end

    describe ProviderMetoffice, "#extract" do
      it "extract" do
        content = IO.read("test/resources/metoffice/stockport-3h.json")
        provider = ProviderMetoffice.new
        provider.fetcher = Fetcher.new
        provider.fetcher.stub(:getUrl).and_return(content)
        result = provider.fetch(123)
        assert_equal(38, result.count)
        assert_equal('Heavy rain shower', result[0].summary)
        assert_equal(8, result[0].temp_min)
        assert_equal(8, result[0].temp_max)
        assert_equal(25, result[0].wind_speed)
        assert_equal('WSW', result[0].wind_dir)
        assert_equal(DateTime.new(2013, 9, 16), result[0].date)
        assert_equal("06:00", result[0].daytime)
        assert_equal("09:00", result[1].daytime)
        assert_equal("12:00", result[2].daytime)
        assert_equal("15:00", result[3].daytime)
        assert_equal("18:00", result[4].daytime)
        assert_equal("21:00", result[5].daytime)
      end
    end
  end
end