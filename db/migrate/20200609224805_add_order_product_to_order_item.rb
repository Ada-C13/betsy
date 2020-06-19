class AddOrderProductToOrderItem < ActiveRecord::Migration[6.0]
  def change
    add_reference :order_items,:order,index:true
    add_reference :order_items,:product,index:true
  end
end
