require 'fetcher'

module Wsm
  describe Wsm do
    describe Fetcher, "#fetch" do
      it "fetch page" do
        fetcher = Fetcher.new
        content = fetcher.getUrl('http://www.bbc.co.uk/weather/2636882')
      end
    end
    describe Fetcher, "#get_user_agent" do
      it "user agent" do
        fetcher = Fetcher.new
        result = fetcher.get_user_agent
        result.should_not be_nil
        result = fetcher.get_user_agent
        result.should_not be_nil
      end
    end
  end

end