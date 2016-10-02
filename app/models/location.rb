class Location < ActiveRecord::Base
  belongs_to :provider
  has_many :search_results
  has_many :searches, :through => :search_results, class_name: "Search"
  def to_s
    "#{provider.name},#{token},#{name}"
  end

  def as_json(options={})
    {
      id: self.id,
      name: self.name
    }
  end
end
