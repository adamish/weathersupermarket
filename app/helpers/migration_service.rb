class MigrationService

  def initialize
    @provider_bbc = Provider.where('name = ?', 'bbc').first;
    @provider_metcheck = Provider.where('name = ?', 'metcheck').first;
    @provider_metoffice = Provider.where('name = ?', 'metoffice').first;
    @provider_weatherunderground = Provider.where('name = ?', 'weatherunderground').first;
    @provider_weatherchannel = Provider.where('name = ?', 'weatherchannel').first;
    @provider_accuweather = Provider.where('name = ?', 'accuweather').first;

    @convert = Hash.new
    @convert['bbc'] = @provider_bbc
    @convert['metcheck'] = @provider_metcheck
    @convert['metoffice'] = @provider_metoffice
    @convert['wunderground'] = @provider_weatherunderground
    @convert['weatherchannel'] = @provider_weatherchannel
    @convert['accuweather'] = @provider_accuweather
  end
  def get_location(provider, token)
    result = nil
    if token != nil && token.strip.length > 0 then
      result = Location.where('provider_id = ? AND token = ?', provider.id, token).first
      if (result == nil)
        puts "Cannot find #{token} #{provider.to_json}"
      end
    end
    result
  end

  def lazy_location(provider, token, name)
    result = Location.where('provider_id = ? AND token = ?', provider.id, token).first
    if (result == nil)
      result = Location.create(:provider => provider, :token => token, :name => name)
    end
    result
  end

  def lazy_quicklink(quicklink)
    result = Quicklink.where('quicklink = ?', quicklink).first
    if (result == nil)
      result = Quicklink.create(:quicklink => quicklink)
    end
    result
  end


  def get_provider(provider_name)
    @convert[provider_name]
  end

  def import_locations

    ActiveRecord::Base.transaction do
      results = LegacyDb.connection.execute("SELECT * from location_result")

      results.each{|x|
        provider = get_provider(x['provider_id'])
        if provider != nil
          location = lazy_location( provider, x['forecast_id'], x['text'])
        else
          raise "cannot find provider with ID #{x['provider_id']}"
        end
      }
    end
  end

  def addLocation(quicklink, location)
    if location != nil
      quicklink.locations << location
    end
  end

  def import_quicklinks
    ActiveRecord::Base.transaction do
      results = LegacyDb.connection.execute("SELECT * from quicklinks")
      results.each{|x|
        quicklink = lazy_quicklink(x['quicklink'])
        addLocation(quicklink, get_location(@provider_bbc, x['id_bbc']))
        addLocation(quicklink, get_location(@provider_metoffice, x['id_metoffice']))
        addLocation(quicklink, get_location(@provider_metcheck, x['id_metcheck']))
        addLocation(quicklink, get_location(@provider_weatherunderground, x['id_wunderground']))
        addLocation(quicklink, get_location(@provider_weatherchannel, x['id_weatherchannel']))
        addLocation(quicklink, get_location(@provider_accuweather, x['id_accuweather']))
      }
    end
  end

  def cleanup
    ActiveRecord::Base.connection.execute("DELETE FROM locations WHERE id in (SELECT l.id FROM locations l LEFT JOIN quicklink_locations a ON a.location_id = l.id WHERE a.quicklink_id IS NULL)")
    ActiveRecord::Base.connection.execute("DELETE FROM quicklinks WHERE id in (SELECT q.id FROM  quicklinks q LEFT JOIN quicklink_locations a ON a.quicklink_id = q.id GROUP BY a.quicklink_id HAVING COUNT(a.quicklink_id) = 0)")
  end
end
