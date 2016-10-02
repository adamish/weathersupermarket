require 'quicklinks_service'

module Wsm
  describe Wsm do
    describe QuicklinksService, "#get_link" do
      it "fetch existing" do
        service = QuicklinksService.new
        locations = Array.new
        result = service.get_link([Location.find(1), Location.find(2), Location.find(3)]);
        assert_equal('abc123', result.quicklink)
      end

      it "fetch existing reverse" do
        service = QuicklinksService.new
        locations = Array.new
        result = service.get_link([Location.find(3), Location.find(2), Location.find(1)]);
        assert_equal('abc123', result.quicklink)
      end

      it "fetch subset" do
        service = QuicklinksService.new
        locations = Array.new
        result = service.get_link([Location.find(1),  Location.find(3)]);
        assert_not_equal('abc123', result.quicklink)
        assert_equal(2, Quicklink.where("quicklink = ?", result.quicklink).first.locations.count)
      end
    end
    describe QuicklinksService, "#generate_unique_id" do
      it "generate" do
        service = QuicklinksService.new
        id1 = service.generate_unique_id
        id2 = service.generate_unique_id
        assert_not_equal(id1, id2)
        assert_equal(8, id1.length)
      end
    end
  end
end