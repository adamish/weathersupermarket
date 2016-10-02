class Search < ActiveRecord::Base
  has_many :search_results
  has_many :locations, :through => :search_results, class_name: "Location"
end
