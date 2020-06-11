require "test_helper"

describe OrdersController do

  let(:existing_order) { Order.new(status: "pending") }
  valid_statuses   = %w(pending paid complete cancelled)
  invalid_statuses = ["parrot", "parakeet", "incomplete", "nope", 2021, nil]

  describe "index" do
    it "succeeds when there are orders" do
      # Arrange
      existing_order.save!

      # Act
      get orders_path

      # Assert
      must_respond_with :success
    end

    it "succeeds when there are no orders" do
      # Arrange
      Order.all do |order|
        order.destroy
      end

      # Act
      get orders_path

      # Assert
      must_respond_with :success
    end
  end # describe "index"

  describe "new" do
    it "succeeds" do
      # Act
      get new_order_path

      # Assert
      must_respond_with :success
    end
  end # describe "new"

  describe "create" do
    it "creates a order with valid data for a real status" do
      # Arrange
      new_order = { order: { status: "pending" } }

      # Act & Assert
      expect {
        post orders_path, params: new_order
      }.must_change "Order.count", 1
      new_order_id = Order.last.id

      must_respond_with :redirect
      must_redirect_to order_path(new_order_id)
    end

    it "renders 400 bad_request for bogus statuses" do
      invalid_statuses.each do |status|
        # Arrange
        invalid_order = { order: { status: status } }

        # Assert
        expect {
          post orders_path, params: invalid_order
        }.wont_change "Order.count"

        must_respond_with :bad_request
      end
    end
  end # describe "create"

  describe "show" do
    it "succeeds for an existing order ID" do
      # Arrange
      existing_order.save!

      # Act
      get order_path(existing_order.id)

      # Assert
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
      destroyed_id = existing_order.id
      existing_order.destroy
      
      # Act
      get order_path(destroyed_id)

      # Assert
      must_respond_with :not_found
    end
  end # describe "show"

  describe "edit" do
    it "succeeds for an existing order ID" do

      # Act
      get edit_order_path(existing_order.id)

      # Assert
      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
      destroyed_id = existing_order.id
      existing_order.destroy

      # Act
      get edit_order_path(destroyed_id)

      # Assert
      must_respond_with :not_found
    end
  end # describe "edit"

  describe "update" do
    it "succeeds for valid data and an extant order ID" do
      # Arrange
      updates = { order: {customer_email: "ada@gmail.com" } }

      # Act & Assert
      expect {
        put order_path(existing_order), params: updates
      }.wont_change "Order.count"
      existing_order.reload

      expect(updated_order.customer_email).must_equal "ada@gmail.com"
      must_respond_with :redirect
      must_redirect_to order_path(existing_order.id)
    end

    it "renders bad_request for bogus data" do
      # Arrange
      updates = { order: { status: nil } }

      # Act & Assert
      expect {
        put order_path(existing_order), params: updates
      }.wont_change "Order.count"

      existing_order.reload

      expect(existing_order.status).must_equal "pending"
    end

#     it "renders 404 not_found for a bogus order ID" do
#       bogus_id = existing_order.id
#       existing_order.destroy

#       # Act
#       put order_path(bogus_id), params: { order: { title: "Test Title" } }

#       # Assert
#       must_respond_with :not_found
#     end
#   end # describe "update"

#   describe "destroy" do
#     it "succeeds for an extant order ID" do
#       expect {
#         delete order_path(existing_order.id)
#       }.must_change "Order.count", -1

#       # Assert
#       must_respond_with :redirect
#       must_redirect_to root_path
#     end

#     it "renders 404 not_found and does not update the DB for a bogus order ID" do
#       bogus_id = existing_order.id
#       existing_order.destroy

#       expect {
#         delete order_path(bogus_id)
#       }.wont_change "Order.count"

#       # Assert
#       must_respond_with :not_found
#     end
#   end # describe "destroy"

#   describe "upvote" do
#     it "redirects to the order page if no user is logged in" do
#       skip
#     end

#     it "redirects to the order page after the user has logged out" do
#       skip
#     end

#     it "succeeds for a logged-in user and a fresh user-vote pair" do
#       skip
#     end

#     it "redirects to the order page if the user has already voted for that order" do
#       skip
#     end
#   end # describe "upvote"

# end
