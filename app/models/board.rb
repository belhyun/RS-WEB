class Board < ActiveRecord::Base
  belongs_to :route, :counter_cache => true
  belongs_to :region
  belongs_to :station
  has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments
end
