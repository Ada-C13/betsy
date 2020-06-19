require "test_helper"

describe HomepagesController do
 
  it "must get index" do
    get products_path
    must_respond_with :success
  end

  it "must get meet the team path" do
    get meet_the_team_path
    must_respond_with :success
  end

end


