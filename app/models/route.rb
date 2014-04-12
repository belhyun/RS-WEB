class Route < ActiveRecord::Base
  belongs_to :region
  has_many :stations, :dependent => :destroy
  has_many :boards
end
