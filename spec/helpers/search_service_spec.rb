require 'search_service'

module Wsm
  describe Wsm do
    describe SearchService, "#search" do
      it "fetch existing" do
        provider = double('foo', {fetch: []})
        ProviderFactory.any_instance.stub(:getProvider).and_return(provider)
        result = SearchService.instance.request('stockport')
        assert_equal(result.length, 3)
      end
    end
    describe SearchService, "#save" do

      it "find new locations" do
        Provider.all[1].should_not be_nil

        locations = Array.new
        locations.push(Location.new(token: 'SS1', name: 'hud - slaithwaite'))
        locations.push(Location.new(token: 'SS2', name: 'hud - golcar'))

        provider = double('foo', {fetch: [], search: locations})
        ProviderFactory.any_instance.stub(:getProvider).and_return(provider)

        assert_equal(3, Location.count)

        result = SearchService.instance.request('huddersfield')
        assert_equal(2 * 6, result.count)
        
        assert_equal(5, Location.count)
      end
    end
  end
end