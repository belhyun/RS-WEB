class UserRoute < ActiveRecord::Base
  belongs_to :route, :dependent => :destroy
  belongs_to :region, :dependent => :destroy
  belongs_to :user, :dependent => :destroy
end
