class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #include ActiveModel::ForbiddenAttributesProtection
  has_one :token
  attr_accessor :password

  def before_save
    #encrypted_password = 'whdgus2'
  end
end
