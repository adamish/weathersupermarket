require 'spec_helper'
require 'extraction'

module Wsm
  describe Wsm do
    describe ForecastService, "#fetch" do

      before(:each) do
        provider = double('foo', {fetch: [Forecast.new(:summary => 'sunny', :temp_max => 30)]})
        ProviderFactory.any_instance.stub(:getProvider).and_return(provider)
        Forecast.stub(:save)
        @location = Location.find(1)
      end

      it "does not fetch if done recently" do
        DateTime.stub(:now).and_return(DateTime.new(2014,1,14))
        Forecast.any_instance.should_not_receive(:save)
        @location.last_fetch = DateTime.now
        result = ForecastService.new.fetch([@location])
      end

      it "fetches when data stale" do
        DateTime.stub(:now).and_return(DateTime.new(2014,1,22))
        StarRating.stub(:get_stars).and_return(3)
        Forecast.any_instance.should_receive(:save)
        result = ForecastService.new.fetch([@location])
      end
    end
  end
end