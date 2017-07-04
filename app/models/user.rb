class User < ApplicationRecord

  # ====================== Constants ======================= #
  ADMIN_EMAILS = ['ashish.garg@headerlabs.com', '01ashishgarg@gmail.com']

  # ====================== Devise ========================== #
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # ====================== Associations ==================== #
  has_many :cart_items, class_name: 'Cart', inverse_of: :user, dependent: :destroy
  has_many :order_headers, class_name: 'Order::Header', inverse_of: :user
  has_many :order_details, class_name: 'Order::Detail', through: :order_headers
  has_many :item_pricings
  has_many :items, through: :item_pricings

  # ====================== Validations ===================== #
  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  validates :email, presence: true
  validates :phone, presence: true
  validates :address, presence: true

  # ====================== Scope =========================== #
  # default_scope -> { where('email not in (?)', ADMIN_EMAILS) }

  # ====================== Callbacks======================== #
  after_create :generate_item_pricings

  def cart_total_value
    cart_items.collect { |x| [x.quantity, ItemPricing.item_price(x.item, self).price].inject(&:*) }.inject(&:+)
  end

  private
  def generate_item_pricings
    Item.all.each do |_item|
      ItemPricing.create(item: _item, user: self, price: _item.price || Item::DEFAULT_PRICE)
    end
  end
end
