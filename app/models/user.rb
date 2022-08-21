class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable

#=begin
  def valid_password?(pass)
    stretches = Rails.application.config.devise.stretches
    pepper = Rails.application.config.devise.pepper

    begin
      super(pass)
    rescue BCrypt::Errors::InvalidHash
      return false unless ::Devise::Encryptable::Encryptors::Custom.digest(pass, stretches, self.password_salt, pepper)
      self.password = pass
      self.password_salt = ""
      self.save!
    end
  end
  alias_method :devise_valid_password?, :valid_password?
#=end

end
