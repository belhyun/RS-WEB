class Follow < ActiveRecord::Base
  belongs_to :users, :counter_cache => true
  before_save :presence_check
  
  def presence_check
    raise ActiveRecord::RecordNotFound, 'follower not found' if User.find_by_id(follow_id).blank?
  end
end
