class User < ActiveRecord::Base
  has_secure_password

  validates :email, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :username, uniqueness: { case_sensitive: false }, presence: true
  validates :auth_token, uniqueness: true, allow_nil: true

  before_create :set_auth_token

  # find other users within a certain distance
  def nearby(distance: 30)
    # 3959 if miles; 6271 if km
    lat = self.lat
    lng = self.lng
    q = User.select("*,
      ( 3959 * acos (
          cos ( radians(#{lat}) )
          * cos( radians( lat ) )
          * cos( radians( lng ) - radians(#{lng}) )
          + sin ( radians(#{lat}) )
          * sin( radians( lat ) )
      )) AS distance").to_sql
    User.from(Arel.sql("(#{q}) AS users")).
    where('distance <= ?', distance).
    where.not(id: self.id)
  end

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
