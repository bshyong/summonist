class User < ActiveRecord::Base
  has_secure_password

  validates :email, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :username, uniqueness: { case_sensitive: false }, presence: true
  validates :auth_token, uniqueness: true, allow_nil: true

  def set_auth_token
    return if auth_token.present?
    loop do
      self.auth_token = generate_auth_token
      break unless User.exists?(auth_token: auth_token)
    end
  end

  def set_auth_token!
    set_auth_token
    save
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end
end
