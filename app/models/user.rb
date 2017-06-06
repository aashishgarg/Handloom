class User < ApplicationRecord

  # ====================== Constants ======================= #
  ADMIN_EMAILS = ['ashish.garg@headerlabs.com', '01ashishgarg@gmail.com']

  # ====================== Devise ========================== #
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # ====================== Associations ==================== #
  has_many :cart_items, class_name: 'Cart', inverse_of: :user, dependent: :destroy
  has_many :order_headers, class_name: 'Order::Header', inverse_of: :user
  has_many :order_details, class_name: 'Order::Detail', through: :order_headers

  # ====================== Validations ===================== #
  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  validates :email, presence: true
  validates :phone, presence: true
  validates :address, presence: true

  # ====================== Scope =========================== #
  # default_scope -> { where('email not in (?)', ADMIN_EMAILS) }
end
