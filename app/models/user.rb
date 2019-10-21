class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  before_save :downcase

  VALID_EMAIL_REGEX = Settings.models.user.email_regex
  
  validates :name, presence: true, length: {maximum: Settings.models.user.namevalidates}
  validates :email, presence: true, length: {maximum: Settings.models.user.emaillvalidates},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum:  Settings.models.user.passvalidates}
  has_secure_password
 
  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    def new_tonken
      SecureRandom.urlsafe_base64
    end
  end
  
  def remember
    self.remember_token = User.new_tonken
    update remember_digest: User.digest(remember_token)

  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.now
  end
  
  def forget
    update remember_digest: nil
  end
  
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private  
  
  def downcase
    email.downcase!
  end

  def downcase_email
    self.email = email.downcase
  end
   
  def create_activation_digest
    self.activation_token = User.new_tonken
    self.activation_digest = User.digest(activation_token)
  end
end
