require "digest/md5"
require "digest/sha2"

module Devise
  module Encryptable
    module Encryptors

      class Legacy < Base
        def self.digest(password, stretches, salt, pepper)
          digest = ::Digest::MD5.hexdigest([password, salt].flatten.join(''))
        end
      end

      class Custom < Base
        def self.update_digest(password, stretches, salt, pepper)
          1.upto(stretches).reduce(password) { |acc, x| Digest::SHA1.hexdigest([acc, salt, pepper].flatten.join('--')) }
        end

        def self.digest(password, stretches, salt, pepper)
          digest_legacy = Legacy.digest(password, stretches, salt, pepper)
          self.update_digest(digest_legacy, stretches, salt, pepper)
        end
      end

    end
  end
end
