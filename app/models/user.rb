class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #include ActiveModel::ForbiddenAttributesProtection
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates_presence_of :email, :password
  validates_uniqueness_of :email, :on => :save
  has_one :token, :autosave => true, :dependent => :destroy
  attr_accessor :password
  scope :getUserWithToken, lambda{|k,v| find(:first, :conditions => ["#{k} = ?", v], :include => [:token])}

  def encrypted_password=(password) 
    write_attribute(:encrypted_password, Digest::SHA1::hexdigest(password))
  end

  def signIn
    if (user = User.getUserWithToken(:email, email)) 
.blank? 
      raise ActiveRecord::RecordNotFound , 'user not found' 
    else
      if User.update_counters user.id, :sign_in_count => 1
        user.build_token.update_attributes(Token.new.gen_token)
        user
      end
    end
  end
end
