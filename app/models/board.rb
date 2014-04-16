class Board < ActiveRecord::Base
  belongs_to :route, :counter_cache => true
  belongs_to :region
  belongs_to :station
  has_many :files, :dependent => :destroy
  mount_uploader :file, FileUploader
end
