require 'rails_helper'
require "#{Rails.root}/lib/update_database"

RSpec.describe User, type: :model do

  plain_password = "abcd1234"
  password_salt = "E8"

  stretches = Rails.application.config.devise.stretches
  pepper = Rails.application.config.devise.pepper

  encrypted_password_legacy = ::Devise::Encryptable::Encryptors::Legacy.digest(plain_password, 1, password_salt, "")

  encrypted_password_custom = ::Devise::Encryptable::Encryptors::Custom.digest(plain_password, stretches, password_salt, pepper)

  before(:all) do
    User.all.delete_all
  end

  if Rails.application.config.devise.encryptor == :legacy
    context "Legacy authentication" do

      let!(:user) {User.create(email: "user1@wizis.com", encrypted_password: encrypted_password_legacy, password_salt: password_salt)}

      it "Success to login" do
        expect(user.valid_password?("abcd1234")).to be_truthy
      end
    end

  elsif Rails.application.config.devise.encryptor == :custom
    context "Custom authentication" do

      let!(:user) {User.create(email: "user1@wizis.com", encrypted_password: encrypted_password_legacy, password_salt: password_salt)
        ::Lib::UpdateDatabase::update_db()
        User.find_by(email: "user1@wizis.com")}

      it "Success to login" do
        expect(user.valid_password?("abcd1234")).to be_truthy
      end
    end

  elsif !Rails.application.config.devise.encryptor # Rails standard
    context "Rails standard autentication" do

      let!(:user) {User.create(email: "user1@wizis.com", encrypted_password: encrypted_password_legacy, password_salt: password_salt)
        ::Lib::UpdateDatabase::update_db()
        User.find_by(email: "user1@wizis.com")}

      it "Success to login" do
        expect(user.valid_password?("abcd1234")).to be_truthy
      end

       it "Update the password though devise_valid_password? and Success to login" do
        expect(user.encrypted_password).to eq(encrypted_password_custom)
        expect(user.password_salt).to eq(password_salt)
        expect(user.valid_password?("abcd1234")).to be_truthy

        expect(user.encrypted_password).to_not eq(encrypted_password_custom)
        expect(user.password_salt).to_not eq(password_salt)
        expect(user.password_salt).to eq("")
        expect(user.valid_password?("abcd1234")).to be_truthy
      end

    end
  end
end
