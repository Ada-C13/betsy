require 'simplecov'

SimpleCov.start do
  add_filter "test/"
  add_filter "app/channels/"
  add_filter "apps/jobs/"
  add_filter "app/mailers/"
  add_filter "bin/spring"
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"


Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  fixtures :all

  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(user)
    return {
      provider: "github",
      uid: user.uid,
      info: {
        email: user.email_address,
        nickname: user.name
      }
    }
  end

  def login(user = nil)
    user ||= User.first
    
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

    get auth_callback_path
        
    return user
  end
end
