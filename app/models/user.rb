class User < ActiveRecord::Base
 attr_accessor :password
 @email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  before_save :encrypt_password
  after_save :clear_password
  validates :password, confirmation: true
  validates :email, :username, :password, presence: true
  validates :email, format: {with: @email_regex, message: "format doesnt match" }
  validates :username, format: { without: /\s/, message: "only string is allowed" } #cek spasi


  def self.authenticate(username_or_email, login_password)
  	if @email_regex.match(username_or_email)
  		user=User.find_by_email(username_or_email)
  	else
  		user=User.find_by_username(username_or_email)
  	end

  	if(user && user.encrypted_password=BCrypt::Engine.hash_secret(login_password, user.salt))
  		return user
  	else
  		return false
  	end
  end

  def encrypt_password
    unless password.blank?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end


end