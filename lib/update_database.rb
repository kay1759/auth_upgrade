module Lib
  module UpdateDatabase
    def self.update_db()
      stretches = Rails.application.config.devise.stretches
      pepper = Rails.application.config.devise.pepper
      User.all.each do |user|
        user.encrypted_password = ::Devise::Encryptable::Encryptors::Custom.update_digest(user.encrypted_password, stretches, user.password_salt, pepper)
        user.save!
      end
    end
  end
end
