class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #include ActiveModel::ForbiddenAttributesProtection
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :new }
  validates_presence_of :email, :password
  validates_uniqueness_of :email
  has_one :token
  attr_accessor :password

  def encrypted_password=(password) 
    write_attribute(:encrypted_password, Digest::SHA1::hexdigest(password))
  end
end
