require "test_helper"

describe Merchant do
  describe "validations" do
    it "requires a username" do
      merchant = Merchant.new
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.messages).must_include :username
    end

    it "requires a unique username" do
      username = "test username"
      email = "test@gmail.com"
      merchant1 = Merchant.new(username: username, email: email)

      # This must go through, so we use create!
      merchant1.save!

      merchant2 = Merchant.new(username: username)
      result = merchant2.save
      expect(result).must_equal false
      expect(merchant2.errors.messages).must_include :username
    end
  end

  describe "relationships" do
    it "has a list of products" do
      merchant1 = merchants(:merchant_2)
      expect(merchant1).must_respond_to :products
      merchant1.products.each do |product|
        expect(product).must_be_kind_of Product
      end
    end
  end

  describe "Custom methods" do
    it "calculate the total_revenue for paid and complete orders" do
      order1 = orders(:paid_order)
      order2 = orders(:paid_order2)
      merchant1 = merchants(:merchant_1)

      expect(merchant1.total_revenue).must_be_close_to 22639.62
    end

    it "num_orders by status" do
      paid_order = orders(:paid_order)
      complete_order = orders(:paid_order2)
      cancelled_order = orders(:cancel_order1)
      cancelled_order2 = orders(:cancel_order2)
      merchant1 = merchants(:merchant_1)

      number_paid = merchant1.num_orders("paid")
      number_cancelled = merchant1.num_orders("cancelled")
      number_complete = merchant1.num_orders("complete")

      expect(number_paid).must_equal 2
      expect(number_cancelled).must_equal 2
      expect(number_complete).must_equal 1
    end

    it "orders by status" do
      paid_order = orders(:paid_order)
      complete_order = orders(:paid_order2)
      cancelled_order = orders(:cancel_order1)
      cancelled_order2 = orders(:cancel_order2)
      merchant1 = merchants(:merchant_1)

      orders_paid = merchant1.orders_by_status("paid")
      orders_cancelled = merchant1.orders_by_status("cancelled")
      orders_complete = merchant1.orders_by_status("complete")

      expect(orders_paid.length).must_equal 2
      expect(orders_cancelled.length).must_equal 2
      expect(orders_complete.length).must_equal 1
    end

    it "total revenue by status" do
      paid_order = orders(:paid_order)
      complete_order = orders(:paid_order2)
      cancelled_order = orders(:cancel_order1)
      cancelled_order2 = orders(:cancel_order2)
      merchant1 = merchants(:merchant_1)

      orders_paid = merchant1.total_by_status("paid")
      orders_cancelled = merchant1.total_by_status("cancelled")
      orders_complete = merchant1.total_by_status("complete")

      expect(orders_paid).must_be_close_to 15093.08
      expect(orders_cancelled).must_be_close_to 15093.08
      expect(orders_complete).must_equal 7546.54
    end
  end
end
