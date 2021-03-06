class User < ApplicationRecord

  # ====================== Devise ========================== #
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # ====================== Associations ==================== #
  has_many :cart_items, class_name: 'Cart', inverse_of: :user, dependent: :destroy
  has_many :order_headers, class_name: 'Order::Header', inverse_of: :user
  has_many :order_details, class_name: 'Order::Detail', through: :order_headers
end
