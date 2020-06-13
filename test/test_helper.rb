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
  
  # Add more helper methods to be used by all tests here...
  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(merchant)
    return{
      provider: merchant.provider,
      uid: merchant.uid,
      info: {
        email: merchant.email,
        nickname: merchant.username
      }
    }
  end
  
  def perform_login(merchant = nil)
    merchant ||= Merchant.first
    
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
    
    get auth_callback_path(:github)
    
    merchant = Merchant.find_by(uid: merchant.uid, username: merchant.username)
    expect(merchant).wont_be_nil
    
    expect(session[:merchant_id]).must_equal merchant.id
    
    return merchant
  end

  def build_order(product_1 = nil, product_2 = nil) # test helper for setting session[:order_id]
    product_1 ||= Product.first
    product_2 ||= Product.second

    order_item_params = {
      quantity: 1
    }

    post add_to_cart_path(product_1.id), params: order_item_params
    post add_to_cart_path(product_2.id), params: order_item_params

    order = Order.last
    expect(session[:order_id]).must_equal order.id

    return order
  end
end
