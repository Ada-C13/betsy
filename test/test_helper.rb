ENV["RAILS_ENV"] ||= "test"
require 'simplecov'

SimpleCov.start do
  add_filter 'test/' # Tests should not be checked for coverage.
end

require_relative "../config/environment"
require "rails/test_help"
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

  # Add more helper methods to be used by all tests here...

  def setup
    # Once you have enabled test mode, all requests
    # to OmniAuth will be short circuited to use the mock authentication hash.
    # A request to /auth/provider will redirect immediately to /auth/provider/callback.
    OmniAuth.config.test_mode = true
  end

  # Test helper method to generate a mock auth hash
  # for fixture data
  # Only into our test, dont mocking in real life
  def mock_auth_hash(merchant)
    return {
        provider: merchant.provider,
        uid: merchant.uid,
        username: merchant.username,
        info: {
          email: merchant.email,
          name: merchant.username,
          nickname: merchant.username,
        },
      }
  end

  def perform_login(merchant = nil)
    merchant ||= Merchant.first
  

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))

    # Act try to callcck route
    get omniauth_calback_path(:github)
    # Need to find that merchant, new merchant: id is nil. Needs go back and find the merchant.
    Merchant.find_by(uid: merchant.uid, username: merchant.username)
    merchant = Merchant.find_by(uid: merchant.uid, username: merchant.username)
    # expect(merchant).wont_be_nil

    # Verify the Merchant ID was saved - If that didn't wwork, this test in invalid
    # expect(session[:merchant_id]).must_equal merchant.id
    return merchant
  end

  def create_order
    post orders_path
    order = Order.last
    product = products(:product_1)

    order_item = OrderItem.create(order: order, product: product, quantity: 2)

    # Verify the order ID was saved - if that didn't work, this test is invalid
    expect(session[:order_id]).must_equal order.id

    return order
  end
end
