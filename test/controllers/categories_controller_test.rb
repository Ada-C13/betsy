require "test_helper"

describe CategoriesController do
  it "must get index" do
    get categories_index_url
    must_respond_with :success
  end

  it "must get show" do
    get categories_show_url
    must_respond_with :success
  end

  it "must get new" do
    get categories_new_url
    must_respond_with :success
  end

  it "must get create" do
    get categories_create_url
    must_respond_with :success
  end

  it "must get edit" do
    get categories_edit_url
    must_respond_with :success
  end

  it "must get update" do
    get categories_update_url
    must_respond_with :success
  end

end
