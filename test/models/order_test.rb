require "test_helper"

describe Order do
  before do
    @product = products(:leash)
    @order = orders(:order1)
    @order_item = OrderItem.create(quantity: 2, order: @order, product: @product, order_item_status: "paid")
  end

  describe 'validations' do
    it 'is valid when all fields are present' do
      result = @order.valid?

      expect(result).must_equal true
    end

    it 'is invalid without an email address' do
      @order.email_address = nil
    
      result = @order.valid?
    
      expect(result).must_equal false
      expect(@order.errors.messages).must_include :email_address

    end

  end

  describe "order_has_to_have_at_least_one_order_item_to_be_placed works" do
    it "raises error if order doesn't have an order item" do
      @order.order_items.each do |order_item|
        order_item.destroy    
      end
      result = @order.valid?

      expect(result).must_equal false
    end
  end

  describe "calculate_order_total works" do
    it "correctly calculates order total" do
      amt = @order.calculate_order_total
      calculated_amt = @order.order_items.map{|order_item| order_item.quantity * order_item.product.price}.sum
      expect(amt).must_equal calculated_amt
    end
  end

  describe "set_status_of_order_items_to_paid works" do
    it "sets the status of each order item to paid" do
      @order.set_status_of_order_items_to_paid
      @order.order_items.each do |order_item|
        expect(order_item.order_item_status).must_equal "paid"
      end
    end
  end


  describe "set_status_of_order_to_complete_if_order_items_are_shipped works" do
    it "if all order items are paid, set order to complete" do
      @order.order_items.each do |order_item|
        order_item.order_item_status = "shipped"
        order_item.save
      end

      @order.set_status_of_order_to_complete_if_order_items_are_shipped
      expect(@order.order_status).must_equal "complete"
    end
  end

end
