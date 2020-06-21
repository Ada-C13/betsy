require 'simplecov'
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

SimpleCov.start do
  add_filter 'test/'
end
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors) # causes out of order output.

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(merchant)
    return {
      provider: merchant.provider,
      uid: merchant.uid,
      info: {
        username: merchant.username,
        email: merchant.email,
      },
    }
  end

  # Helper method that performs a log-in with either
  # a passed-in user or the first test user
  def perform_login(merchant = nil)
    merchant ||= Merchant.first
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))

    # Act Try to call the callback route
    get auth_callback_path(:github)

    merchant = Merchant.find_by(uid: merchant.uid, username: merchant.username)
    expect(merchant).wont_be_nil

    # Verify the user ID was saved - if that didn't work, this test is invalid
    expect(session[:merchant_id]).must_equal merchant.id
    return merchant
  end
end
