require 'migration_service'

module Wsm
  describe Wsm do
    describe MigrationService, "#import_quicklinks" do

      it "location import" do
#
#        service = MigrationService.new
#
#        LegacyDb.connection.execute("DELETE FROM location_result")
#        LegacyDb.connection.execute("INSERT INTO location_result (provider_id, forecast_id, text) VALUES ('accuweather', 'LON', 'London')")
#        LegacyDb.connection.execute("INSERT INTO location_result (provider_id, forecast_id, text) VALUES ('bbc', 'HUD', 'Huddersfield')")
#        LegacyDb.connection.execute("INSERT INTO location_result (provider_id, forecast_id, text) VALUES ('metcheck', 'MAN', 'Manchester')")
#        LegacyDb.connection.execute("INSERT INTO location_result (provider_id, forecast_id, text) VALUES ('metoffice', 'YRK', 'York')")
#        LegacyDb.connection.execute("INSERT INTO location_result (provider_id, forecast_id, text) VALUES ('weatherchannel', 'BAD', 'Bradford')")
#        LegacyDb.connection.execute("INSERT INTO location_result (provider_id, forecast_id, text) VALUES ('wunderground', 'SPT', 'Stockport')")
#
#        LegacyDb.connection.execute("DELETE FROM quicklinks")
#        LegacyDb.connection.execute("INSERT INTO quicklinks (quicklink,id_accuweather,id_bbc,id_metcheck,id_metoffice,id_weatherchannel,id_wunderground) VALUES ('legacy123', 'LON', 'HUD', 'MAN', 'YRK', 'BAD', 'SPT')")
#
#        service.import_locations
#        service.import_quicklinks
#
#        assert_equal(6, Quicklink.where("quicklink = ?", 'legacy123').first.locations.count)
#
#        Location.where("token = ?", 'HUD').first.should_not be_nil
#        Location.where("token = ?", 'LON').first.should_not be_nil
#        Location.where("token = ?", 'YRK').first.should_not be_nil
#        Location.where("token = ?", 'MAN').first.should_not be_nil
#        Location.where("token = ?", 'BAD').first.should_not be_nil
#        Location.where("token = ?", 'SPT').first.should_not be_nil

      end
    end

  end

end