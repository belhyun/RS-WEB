class Region < ActiveRecord::Base
  has_many :routes, :dependent => :destroy
  has_many :stations, :dependent => :destroy

  def getList
    Region.where(:id => id)
  end
end
