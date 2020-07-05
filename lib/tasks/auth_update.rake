require 'tempfile'
require 'fileutils'
require "#{Rails.root}/lib/update_database"

namespace :auth_update do

  desc "update authontication from legacy to custom, custom to Rails standard"
  task update: :environment do
    if Rails.application.config.devise.encryptor == :legacy
      update_file("/config/initializers/devise.rb",
                  {"config.encryptor = :" => "  config.encryptor = :custom"})
      ::Lib::UpdateDatabase::update_db()
    elsif Rails.application.config.devise.encryptor == :custom
      update_file("/config/initializers/devise.rb",
                  {"config.encryptor = :" => "  # config.encryptor = :custom"})
      update_file("/app/models/user.rb",
                  {"devise :database_authenticatable, :registerable, :encryptable" => "  devise :database_authenticatable, :registerable",
                   "=begin --- auto convert to bcrypt" => "#=begin",
                   "=end" => "#=end"})
    end
  end

  def update_file(filepath, replace_cond_array)
    temp_file = Tempfile.new('devise')
    begin
      File.open("#{Rails.root}#{filepath}", 'r') do |file|
        file.each_line do |line|
          replace_cond_array.each do |key, val|
            line = val if line.include? key
          end
          temp_file.puts line
        end
      end
      temp_file.close
      FileUtils.mv(temp_file.path, "#{Rails.root}#{filepath}")
    ensure
      temp_file.close
      temp_file.unlink
    end
  end
end
