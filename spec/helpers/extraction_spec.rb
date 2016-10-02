require 'spec_helper'
require 'extraction'

module Wsm
  describe Wsm do
    describe Extraction, "#temperature" do
      it "negative" do
        assert_equal(-123, Extraction.temperature("-123"))
      end
    end
    describe Extraction, "#date_a" do
      it "convert same month" do
        TimeService.stub(:now).and_return(Time.new(2013, 9, 15, 9, 30))
        assert_equal(Date.new(2013, 9, 30), Extraction.date_a("Sept 30"))
      end

      it "convert different month" do
        TimeService.stub(:now).and_return(Time.new(2013, 10, 31, 9, 30))
        assert_equal(Date.new(2013, 11, 1), Extraction.date_a("Nov 1"))
      end

      it "convert next year" do
        TimeService.stub(:now).and_return(Time.new(2013, 12, 30, 9, 30))
        assert_equal(Date.new(2014, 1, 2), Extraction.date_a("Jan 2"))
      end
      it "convert same year" do
        TimeService.stub(:now).and_return(Time.new(2014, 1, 2, 9, 30))
        assert_equal(Date.new(2013, 12, 31), Extraction.date_a("Dec 31"))
      end

      it "convert previous year" do
        TimeService.stub(:now).and_return(Time.new(2013, 12, 30, 9, 30))
        assert_equal(Date.new(2014, 1, 2), Extraction.date_a("Jan 2"))
      end
    end

    describe Extraction, "#date_b" do
      it "convert same month" do
        TimeService.stub(:now).and_return(Time.new(2014, 1, 15, 9, 30))
        assert_equal(Date.new(2014, 1, 13), Extraction.date_b("Monday, 13"))
      end

      it "convert next month" do
        TimeService.stub(:now).and_return(Time.new(2014, 1, 27, 9, 30))
        assert_equal(Date.new(2014, 2, 3), Extraction.date_b("Monday, 3"))
      end
      
      it "convert previous month" do
        TimeService.stub(:now).and_return(Time.new(2014, 2, 1, 9, 30))
        assert_equal(Date.new(2014, 1, 27), Extraction.date_b("Monday, 27"))
      end
    end
  end
end