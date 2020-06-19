require "test_helper"

describe OrderItemsController do
  before do
    @collar = order_items(:collar_order_item)
    @leash = order_items(:leash_order_item)
    @bowl = order_items(:bowl_order_item)
    @doghouse = products(:doghouse)
    @order = create_order(@doghouse, 1)
    @leash.order = @order
    @leash.save
  end

  describe "create" do
    it "successfully creates an order item when there is an existing order and order item is in stock" do
      product = products(:bones)
      expect { post product_order_items_path(product),params:{quantity:1} }.must_change "OrderItem.count", 1
      expect(flash[:success]).must_equal "order item succesfully created"
      must_redirect_to product_path(product)
    end

    it "returns error and redirects to product page if not enough inventory" do
      product = products(:bones)
      expect { post product_order_items_path(product),params:{quantity:100} }.wont_change "OrderItem.count"
      expect(flash[:error]).must_equal "Not enough inventory available."
      must_redirect_to product_path(product)
    end

    it "successfully creates order item and order if current order does not exist" do
      patch cancel_order_path(@order.id)
      product = products(:bones)
      expect { post product_order_items_path(product),params:{quantity:1} }.must_change "OrderItem.count", 1
      expect(flash[:success]).must_equal "order item succesfully created"
      expect(session[:order_id]).wont_equal nil
      must_redirect_to product_path(product)
    end

    it "succesfully increments existing order item for same product if quantity is avail" do
      product = products(:rubber_duck)
      post product_order_items_path(product_id: product.id),params:{quantity:1}
      expect { post product_order_items_path(product_id: product.id),params:{quantity:1} }.wont_change "OrderItem.count"
      @order.reload
      expect @order.order_items.find_by(product_id: product.id).quantity.must_equal 2    
    end

    it "does not increment existing order item for same product if quantity is NOT avail" do
      product = products(:rubber_duck)
      post product_order_items_path(product_id: product.id),params:{quantity:1}
      puts "------"
      puts product.stock
      expect { post product_order_items_path(product_id: product.id),params:{quantity:20} }.wont_change "OrderItem.count"
      expect(flash[:error]).must_equal "Not enough inventory available."
      must_redirect_to product_path(product)
      @order.reload
      expect @order.order_items.find_by(product_id: product.id).quantity.must_equal 1 
    end

  end

  describe "update" do
    it "will update a valid order item successfully" do
      updates = { order_item: { quantity: 7 } }

      expect { put order_item_path(@leash), params: updates }.wont_change "OrderItem.count"
      updated_order_item = OrderItem.find_by(id: @leash.id)

      expect(updated_order_item.quantity).must_equal 7
      expect(updated_order_item.product).must_equal products(:leash)
      expect(updated_order_item.order).must_equal @order
      must_respond_with :redirect
      must_redirect_to order_path(@order.id)
    end
    it "will respond with flash error message for updating invalid order item id" do
      updates = { order_item: { quantity: 7 } }
      expect { put order_item_path(-1), params: updates }.wont_change "OrderItem.count"
      flash[:error].must_equal "Could not find order item."
    end
    it "will not update if the params are invalid" do
      updates = { order_item: { quantity: nil } }

      expect { put order_item_path(@leash), params: updates }.wont_change "OrderItem.count"
      updated_order_item = OrderItem.find_by(id: @leash.id)

      expect(@leash.quantity).wont_be_nil
    end
  end
  describe "destroy" do
    it "destroys a valid order item" do
      expect { delete order_item_path(@leash.id) }.must_change "OrderItem.count", -1
      must_respond_with :redirect
      must_redirect_to order_path(@order.id)
    end
    it "will respond with flash error for destroying an invalid order item" do
      expect { delete order_item_path(-1) }.wont_change "OrderItem.count"
      flash[:error].must_equal "Could not find order item."
    end
  end
  describe "change_order_item_status" do
    it "should change the order item status to shipped" do
      patch change_order_item_status_path(@leash)
      @leash.reload
      expect(@leash.order_item_status).must_equal "shipped"
      must_respond_with :redirect
      must_redirect_to myorders_path
    end
  end
end
