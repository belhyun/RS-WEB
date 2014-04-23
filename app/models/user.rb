class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  #include ActiveModel::ForbiddenAttributesProtection
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates_uniqueness_of :email, :on => :save
  validates_presence_of :email, :password, :nick, :on => :create
  has_one :token, :autosave => true, :dependent => :destroy
  attr_accessor :password
  scope :getUserWithToken, lambda{|k,v| find(:first, :conditions => ["#{k} = ?", v], :include => [:token])}
  scope :followers, lambda{|v| joins("INNER JOIN follows ON users.id = follows.follow_id")
                           .where("follows.follow_id = ?", v)}
  has_many :boards, :dependent => :destroy
  has_many :routes, :through => :user_routes, :source => :route
  has_many :user_routes, :source => :user
  has_many :follows, :dependent => :destroy
  mount_uploader :image, ProfileUploader

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

  def self.is_valid_user(user_id)
    User.find_by_id(user_id).token.expires > DateTime.now
  end
end
