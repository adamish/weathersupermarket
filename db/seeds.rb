Provider.delete_all

Provider.create!(:name => 'accuweather')
Provider.create!(:name => 'weatherchannel')
Provider.create!(:name => 'weatherunderground')
Provider.create!(:name => 'metoffice')
Provider.create!(:name => 'metcheck')
Provider.create!(:name => 'bbc')

service = MigrationService.new
#service.import_locations
#service.import_quicklinks
#service.cleanup
if not Rails.env.test?
  puts 'Building metoffice site table'
  metoffice = (ProviderFactory.new).getProvider('metoffice')
  metoffice.build_site_list
end

