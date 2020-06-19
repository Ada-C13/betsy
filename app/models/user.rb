class User < ApplicationRecord

    def self.build_from_github(auth_hash)
        user = User.new
        user.uid = auth_hash[:uid]
        user.provider = "github"
        user.name = auth_hash[:info][:name]
        user.email = auth_hash[:info][:email]
        # will save user outside of this method
        return user
    end

    def total_revenue
        return order_items.map{ |order_item| order_item.calculate_total }.sum
    end

    def filtered_revenue(status)
        filtered_order_items = order_items.select{ |order_item| order_item.order_item_status == status }
        return filtered_order_items.map{ |order_item| order_item.calculate_total }.sum
    end

    def filtered_num_orders(status)
        filtered_order_items = order_items.select{ |order_item| order_item.order_item_status == status }
        return filtered_order_items.count
    end

    def order_items 
        return OrderItem.all.select{ |order_item| order_item.product.user_id == id}
    end



    validates :uid, presence: true, numericality: {only_integer: true}, uniqueness: true
    validates :provider, presence: true

    has_many :products

end
