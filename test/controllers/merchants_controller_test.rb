require "test_helper"

describe MerchantsController do
  it "must get index" do
    get merchants_index_url
    must_respond_with :success
  end

  it "must get show" do
    get merchants_show_url
    must_respond_with :success
  end

end
