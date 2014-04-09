class Station < ActiveRecord::Base
  belongs_to :route
  belongs_to :region
end
