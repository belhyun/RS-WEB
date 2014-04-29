class Board < ActiveRecord::Base
  belongs_to :route, :counter_cache => true
  belongs_to :region
  belongs_to :station
  belongs_to :user
  has_many :attachments, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :board_empathies, :dependent => :destroy
  accepts_nested_attributes_for :attachments
  scope :get, lambda {|id| where(:id => id).first}

  def as_json(options)
    options[:except] = [:updated_at]
    super(options)
  end
end
