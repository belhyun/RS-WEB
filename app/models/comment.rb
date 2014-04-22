class Comment < ActiveRecord::Base
  belongs_to :boards, :counter_cache => true
end
