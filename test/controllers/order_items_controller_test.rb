require "test_helper"

describe OrderItemsController do
  it "must get create" do
    get order_items_create_url
    must_respond_with :success
  end

  it "must get update" do
    get order_items_update_url
    must_respond_with :success
  end

  it "must get edit" do
    get order_items_edit_url
    must_respond_with :success
  end

  it "must get destroy" do
    get order_items_destroy_url
    must_respond_with :success
  end

end
