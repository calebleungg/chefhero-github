class AdminController < ApplicationController

    # method for admin management
    def manage

        # initial instance of all information on page load for display
        @foodie_database = User.search(params[:foodie_search], "foodie").order("last_name")
        @chef_database = User.search(params[:chef_search], "chefhero").order("last_name")
        @dish_database = Dish.search(params[:dish_search]).order("created_at DESC")
        @order_database = Order.search(params[:order_search]).order("created_at DESC")
        @review_database = Review.search(params[:review_search]).order("created_at DESC")
        
        
        @total_sales = 0
        User.where(account_type: "chefhero").each do |chef|
            @total_sales += chef.get_total_sales
        end
        
        @total_users = User.all.length
        @total_dishes = Dish.all.length
        @total_orders = Order.all.length
        @total_reviews = Review.all.length

        render layout: "admin"
    end

end
