class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable

    has_many :reviews
    has_many :dishes
    has_one_attached :avatar
    has_many :orders
    has_one :address
    has_one :availability
    has_many :withdrawals

    def name
        return "#{first_name} #{last_name}"
    end

    def get_dish_ids
        ids = []
        for dish in self.dishes
            ids.push(dish.id)
        end
        return ids
    end

    def get_display_picture
        return self.avatar.attached? ? self.avatar : "default-profile.png"
    end

    def get_withdrawn_total
        sum = 0
        records = self.withdrawals
        for record in records
            sum += record.amount
        end
        return sum
    end

    def get_total_sales
        orders = Order.where(dish_id: self.get_dish_ids)
        net = 0
        for order in orders
            net += order.get_total
        end
        return net
    end

    def get_total_orders
        orders = Order.where(dish_id: self.get_dish_ids)
        return orders.length
    end

    def self.top_five_chefs
        chefs = User.where(account_type: "chefhero")
        chef_to_orders = {}
        for chef in chefs
            chef_to_orders[chef.id] = chef.get_total_orders
        end
        sorted = chef_to_orders.sort_by(&:last).reverse[0..3]
        return sorted

    end

end
