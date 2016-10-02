require 'star_rating'

module Wsm
  describe Wsm do
    describe StarRating, "#get_stars" do
      it "5 star" do
        f = Forecast.new(:summary => 'sunny', :temp_max => 30)
        result = StarRating.process(f)
        assert_equal(5, result[0])
      end
      it "1 star" do
        f = Forecast.new(:summary => 'storm rain', :temp_max => 5)
        result = StarRating.process(f)
        assert_equal(1, result[0])
      end
      it "sun symbol" do
        f = Forecast.new(:summary => 'sunny', :temp_max => 30)
        result = StarRating.process(f)
        assert_equal('sun', result[1])
      end
      it "rain symbol" do
        f = Forecast.new(:summary => 'storm rain', :temp_max => 5)
        result = StarRating.process(f)
        assert_equal('rain1', result[1])
      end
    end

    describe StarRating, "#get_logical" do
      it "cloud" do
        result = StarRating.get_logical('partly cloudly, clearing later')
        result[:cloud].should_not be_nil
      end

      it "storm" do
        result = StarRating.get_logical('a big thunderstorm coming')
        result[:thunder].should_not be_nil
      end

      it "snow" do
        result = StarRating.get_logical("we're expecting snow")
        result[:snow].should_not be_nil
      end

      it "rain" do
        result = StarRating.get_logical("we're expecting heavy rain over bradford, oh yes")
        result[:rain].should_not be_nil
      end

      it "case insensitive" do
        result = StarRating.get_logical('LOTS OF RAIN CLOUDS')
        result[:rain].should_not be_nil
      end
    end
  end

end