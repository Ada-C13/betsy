require "test_helper"

describe OrderItemsController do

  it "must get edit" do
    get order_item_path
    must_respond_with :success
  end


end
