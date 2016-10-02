class SearchResult < ActiveRecord::Base
  belongs_to :location
  belongs_to :search
end
