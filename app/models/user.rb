class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.models.user.email_regex
  before_save :downcase
  
  validates :name, presence: true, length: {maximum: Settings.models.user.namevalidates}
  validates :email, presence: true, length: {maximum: Settings.models.user.emaillvalidates},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum:  Settings.models.user.passvalidates}

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  private  
  def downcase
    email.downcase!
  end
end
