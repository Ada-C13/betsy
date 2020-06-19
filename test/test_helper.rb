ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"  # for Colorized output
require "simplecov"
SimpleCov.start "rails" do
  add_filter "app/channels/"
  add_filter "app/jobs/"
  add_filter "app/mailers/"
  add_filter "/bin/"
  add_filter "/db/"
  add_filter "/test/"
  add_filter "app/helpers/"
end
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

  def mock_auth_hash(user)
    return {
             provider: user.provider,
             uid: user.uid,
             info: {
               email: user.email,
               name: user.name,
             },
           }
  end

  def perform_login(user = nil)
    user ||= User.first

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path(:github)

    return user
  end

  def create_order(product, quantity)
    post product_order_items_path(product.id), params: { quantity: quantity }
    order = Order.find_by(id: session[:order_id])
    expect(session[:order_id]).must_equal order.id
    return order
  end
end

# user.uid = auth_hash[:uid]
# user.provider = "github"
# user.username = auth_hash["info"]["name"]
# user.email = auth_hash["info"]["email"]
