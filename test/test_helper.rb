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

  def mock_auth_hash(merchant)
    return {
      provider: merchant.provider,
      uid: merchant.uid,
      info: {
        nickname: merchant.name,
        email: merchant.email,
      },
    }
  end

  def perform_login(merchant = nil)
    merchant ||= Merchant.first
    # telling the omniauth that we need you to create a mock up hash for github, bases on the mock_auth_hash method that we just created
    OmniAuth.config.mock_auth[:github] = OmniAuth:: AuthHash.new(mock_auth_hash(merchant))
    
    # Act try to call the callback route
    get omniauth_callback_path(:github)

    merchant = Merchant.find_by(uid: merchant.uid, name: merchant.name)
    expect(merchant).wont_be_nil

    # Verify the user ID was saved - if that didn't work, this test is invalid
    expect(session[:merchant_id]).must_equal merchant.id

    return merchant
  end
end
