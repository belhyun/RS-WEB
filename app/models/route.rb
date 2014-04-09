class Route < ActiveRecord::Base
  belongs_to :region
  has_many :stations
end
