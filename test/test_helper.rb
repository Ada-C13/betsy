ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
#  For colorful output!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_merchant_hash(user)
    return {
      uid: user.uid,
      provider: user.provider,
      info: {
        nickname: user.name,
        email: user.email
      }
    }
  end

  def perform_login(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_merchant_hash(user))

    get omniauth_callback_path(:github)
  end
end
