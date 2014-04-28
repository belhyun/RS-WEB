class Comment < ActiveRecord::Base
  belongs_to :boards, :counter_cache => true
  belongs_to :user 

  def as_json(options)
    options[:except] = [:created_at, :updated_at]
    super
  end
end
