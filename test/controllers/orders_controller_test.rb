require "test_helper"

describe OrdersController do
  
  it "will show an order " do 
    order = orders(:order1)
    get order_path(order.id)
    must_respond_with :success
  end 

  it "will go to customer info page" do 
    get new_order_path
    must_respond_with :success
  end 

  it "will set order status to cancled" do 
    order = orders(:order1)
    order.save!
    patch order_path(order)
    order.reload
    expect(order.status).must_equal "canceled"

  end 

  it "will not update order status if order is not found" do 
    patch order_path(-1) 
    must_redirect_to root_path
  end 

end
