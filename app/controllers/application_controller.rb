class ApplicationController < ActionController::Base
    before_action :find_user, :find_order, :find_categories, :find_users

    def find_users
        @users = User.all
    end

    def find_user
        if session[:user_id]
            @logged_user = User.find_by(id: session[:user_id])
        else
            @logged_user = nil 
        end
    end

    def find_order
        if session[:order_id]
            @current_order = Order.find_by(id: session[:order_id])
        else
            @current_order = nil
        end
    end

    def find_categories
        @categories = Category.all
    end

end
