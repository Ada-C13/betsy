class OrderItemController < ApplicationController

  def add_to_cart  

    if ((params[:post][:qty]).to_i) < 1 
      flash[:error] = "Before adding to cart please specify a quantity"
      return redirect_to root_path
    end

    if !Product.available?(params["id"], params["post"]["qty"])
      flash[:error] = "Not enough in stock"
      return redirect_to root_path
    end 

    if session[:order_items]
      order_item = session[:order_items].find { |order_item| order_item["product_id"] == params["id"].to_i }
      if !order_item
        session[:order_items] << OrderItem.create!(qty: (params["post"]["qty"]).to_i, product_id: params["id"])
      else
        order_item["qty"] = params["post"]["qty"]
        order_item = OrderItem.find_by(product_id: params["id"])
        order_item.update_attributes!(qty: params["post"]["qty"].to_i) 
        order_item.save
      end
    else
      session[:order_items] = []
      session[:order_items] << OrderItem.create!(qty: params["post"]["qty"], product_id: params["id"])
    end 
    flash[:status] = "Added to Cart!"
    redirect_to root_path
  end 

  def remove_from_cart 
    session[:order_items] = OrderItem.remove_from_cart(session[:order_items], params["format"])
    redirect_to cart_path
  end 

  def cart 
    if session[:order_items].nil? 
      flash[:error] = "You have nothing in your cart!"
      redirect_to root_path
    else
      @cart = OrderItem.display_items(session[:order_items])
      return @cart
    end 
  end 

end
