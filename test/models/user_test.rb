require "test_helper"

describe User do
  describe "build_from_github" do
    it "returns user with expected and required parameters" do
      user = users(:grace)
      user_hash = mock_auth_hash(user)
      puts user_hash
      returned_user = User.build_from_github(user_hash)
      expect(returned_user).must_be_instance_of User
      expect(returned_user.uid).must_equal user.uid
      expect(returned_user.provider).must_equal user.provider
      expect(returned_user.name).must_equal user.name
      expect(returned_user.email).must_equal user.email

    end
  end

  describe "total revenue" do
    it "correctly return the total revenue" do 
      user = users(:grace)
      order_items = user.order_items
      total = 0
      order_items.each do |order_item|
        total += order_item.calculate_total
      end     
      expect(user.total_revenue).must_equal total
    end
  end

  describe "filtered revenue" do
    it "correctly return the filtered total revenue" do 
      user = users(:grace)
      order_items = user.order_items
      total = 0
      order_item_status = "paid"
      order_items.each do |order_item|
        if order_item.order_item_status == order_item_status
          total += order_item.calculate_total
        end
      end     
      expect(user.filtered_revenue(order_item_status)).must_equal total
    end
  end

  describe "filtered revenue" do
    it "correctly return the filtered total revenue" do 
      user = users(:grace)
      order_items = user.order_items
      count = 0
      order_item_status = "paid"
      order_items.each do |order_item|
        if order_item.order_item_status == order_item_status
          count += 1
        end
      end     
      expect(user.filtered_num_orders(order_item_status)).must_equal count
    end
  end


end
