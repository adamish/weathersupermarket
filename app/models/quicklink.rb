class Quicklink < ActiveRecord::Base
  has_many :quicklink_locations
  has_many :locations, :through => :quicklink_locations, class_name: "Location"
end
