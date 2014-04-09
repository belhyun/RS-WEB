class Token < ActiveRecord::Base
  belongs_to :user, touch: true
  before_create :gen_token
  before_update :gen_token

  def gen_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless Token.exists?(token: random_token)
    end
    self.expires = Time.now + 60.days
  end
end
