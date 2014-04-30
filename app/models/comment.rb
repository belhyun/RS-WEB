class Comment < ActiveRecord::Base
  belongs_to :boards, :counter_cache => true
  belongs_to :user 
  has_one :attachment, :dependent => :destroy

  def as_json(options)
    options[:except] = [:created_at, :updated_at]
    super
  end
end
