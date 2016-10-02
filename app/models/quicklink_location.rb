class QuicklinkLocation < ActiveRecord::Base
  belongs_to :quicklink
  belongs_to :location
end
