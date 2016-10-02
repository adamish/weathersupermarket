class ProviderDao
  @@providers = Provider.all
  def initialize
  end
  
  def self.find(id)
    @@providers.select { |it| it.id == id }[0]
  end
end