require "test_helper"

describe ProductsController do

  let (:product1) {
    Product.create!(
      name: "XXXX", 
      price: 20.00,
      stock: 20,
      active: true,
      description: "XXX XXX XXXX XXX XXXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXX XXXXX XXXX XXXXX",
      photo: "https://i.imgur.com/WSHmeuf.jpg",
      merchant: merchants(:merchantaaa)
    )
  }

  describe "index" do
    it "responds with success when there are many products saved" do
      get products_path
      must_respond_with :success
    end

    it "responds with success when there are no product saved" do
      product1.destroy

      get products_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid product" do
      get product_path(product1.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid product id" do
      get product_path(-1)
      must_redirect_to products_path
    end
  end

  describe "new" do
    it "responds with success" do
      get new_product_path
      must_respond_with :success
    end
  end

  # describe "create" do
  #   it "can create a new work with valid information accurately, and redirect" do
  #     # Arrange 
  #     work_hash = {
  #       work: {
  #         category: "movie", 
  #         title: "New Movie",
  #         creator: "XXXX",
  #         publication_year: "2016",
  #         description: "Description for the new movie"
  #       },
  #     } 

  #     # Act-Assert
  #     expect {
  #       post works_path, params: work_hash
  #     }.must_change "Work.count", 1
      
  #     # Assert
  #     new_work = Work.find_by(title: work_hash[:work][:title])
  #     expect(new_work.title).must_equal work_hash[:work][:title]
  #     expect(new_work.category).must_equal work_hash[:work][:category]
  #     expect(new_work.creator).must_equal work_hash[:work][:creator]
  #     expect(new_work.publication_year).must_equal work_hash[:work][:publication_year]
  #     expect(new_work.description).must_equal work_hash[:work][:description]
      
  #     expect(flash[:success]).must_equal " Successfully created #{new_work.category} #{new_work.title}"
  #     must_redirect_to works_path 

  #   end

  #   it "does not create a work if the form data violates Work validations, and responds with a 400 error" do
  #     invalid_work_hash = {
  #       work: {
  #         category: "album", 
  #         title: nil,
  #         creator: "XXXX",
  #         publication_year: "2016",
  #         description: "Description for the new movie"
  #       }
  #     }

  #     expect{flash.now[:error]}.must_raise "A problem occurred: Could not create #{invalid_work_hash[:work][:category]}"
  #     # Act-Assert
  #     expect {
  #       post works_path, params: invalid_work_hash
  #     }.wont_differ "Work.count"

  #     # Assert
  #     must_respond_with :bad_request
  #   end
  # end
  
  # describe "edit" do
  #   it "responds with success when getting the edit page for an existing, valid work" do
  #     get edit_work_path(work1.id)
  #     must_respond_with :success
  #   end

  #   it "responds with redirect when getting the edit page for a non-existing work" do
  #     get edit_work_path(-1)
  #     must_redirect_to works_path
  #   end
  # end

  # describe "update" do
  #   let (:edited_work_hash) {
  #     {
  #       work: {
  #         category: "book", 
  #         title: "ABC",
  #         creator: "Thomas Wison",
  #         publication_year: "2002",
  #         description: "Learning alphabets"
  #       }
  #     }
  #   }
    
  #   it "can update an existing work with valid information accurately, and redirect" do
  #     id = work1.id

  #     expect{
  #       patch work_path(id), params: edited_work_hash
  #     }.must_differ "Work.count", 0

  #     work1.reload
  #     expect(work1.category).must_equal edited_work_hash[:work][:category]
  #     expect(work1.title).must_equal edited_work_hash[:work][:title]
  #     expect(work1.creator).must_equal edited_work_hash[:work][:creator]
  #     expect(work1.publication_year).must_equal edited_work_hash[:work][:publication_year]
  #     expect(work1.description).must_equal edited_work_hash[:work][:description]

  #     expect(flash[:success]).must_equal " Successfully updated #{work1.category} #{work1.title}"
  #     must_redirect_to work_path(id)
  #   end

  #   it "does not update any work if given an invalid id, and responds with a 404" do
  #     expect{
  #       patch work_path(-1), params: edited_work_hash
  #     }.wont_change "Work.count"
      
  #     must_respond_with :not_found
  #   end

  #   it "does not create/update a work if the form data violates Driver validations, and responds with a 400 error" do
  #     id = work1.id

  #     invalid_work_hash = {
  #       work: {
  #         category: "book", 
  #         title: nil,
  #         creator: "XXXX",
  #         publication_year: "2016",
  #         description: "Description for the new movie"
  #       },
  #     }

  #     expect{flash.now[:error]}.must_raise "A problem occurred: Could not update #{invalid_work_hash[:work][:category]}"
  #     expect {
  #       patch work_path(id), params: invalid_work_hash
  #     }.wont_differ "Work.count"

  #     must_respond_with :bad_request
  #   end
  # end

  # describe "destroy" do
  #   it "destroys the work instance in db, then redirects" do
  #     id = work1.id

  #     expect {
  #       delete work_path(id)
  #     }.must_differ "Work.count", -1
  #     expect(flash[:success]).must_equal "Successfully deleted #{work1.category} #{work1.title}"
  #     must_redirect_to works_path
  #   end

  #   it "destroys the work instance in db when work exists and has at least one vote, then redirects" do
  #     id = work1.id

  #     user1 = User.create!(name: "Lak Mok")
  #     user2 = User.create!(name: "Jeta Cathy")

  #     vote1 = Vote.create!(user_id: user1.id, work_id: work1.id)
  #     vote2 = Vote.create!(user_id: user2.id, work_id: work1.id)
      
  #     expect(Vote.where(work_id: work1.id).count).must_equal 2
  #     expect {
  #       delete work_path(id)
  #     }.must_differ "Work.count", -1

  #     expect(Vote.where(work_id: work1.id).count).must_equal 0
  #     expect(flash[:success]).must_equal "Successfully deleted #{work1.category} #{work1.title}"
  #     must_redirect_to works_path
  #   end

  #   it "does not change the db when the work does not exist, then responds with a 400 error" do
  #     id = -1

  #     expect{
  #       delete work_path(id)
  #     }.wont_differ "Work.count"

  #     must_respond_with :not_found
  #   end
  # end
  
end
