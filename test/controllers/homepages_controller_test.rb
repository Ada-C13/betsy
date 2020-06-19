require "test_helper"

describe HomepagesController do

  it "responds with success" do 
    get root_path
    must_respond_with :success 
  end 

end
