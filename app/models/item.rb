class Item < ApplicationRecord

  # =================== Constants ======================== #
  ITEM_STATUS = %w(open closed)

  # =================== Associations ===================== #
  belongs_to :category
  has_many :item_variants, inverse_of: :item, dependent: :destroy

  has_many :colors, class_name: 'Property::Color', through: :item_variants
  has_many :brands, class_name: 'Property::Brand', through: :item_variants
  has_many :sizes, class_name: 'Property::Size', through: :item_variants
  has_many :materials, class_name: 'Property::Material', through: :item_variants

  has_many :item_pricings
  has_many :users, through: :item_pricings

  # =================== Validations ====================== #
  validates :name, presence: true, length: {minimum: 2}
  validates :description, length: {minimum: 2}
  validates :sku, presence: true, length: {minimum: 2}
  validates :new_style_no, length: {minimum: 2}
  validates :status, inclusion: {in: ITEM_STATUS}

  # =================== Pagination ======================= #
  paginates_per 8

  # =================== Callbacks ======================== #
  after_create :create_default_pricings_data

  def self.get_item_variants(item, color_name = nil, size_name = nil)
    color = Property::Color.where(name: color_name).take
    size = Property::Color.where(name: color_name).take

    item.item_variants.where(color: color, size: size)
  end

  def item_price(user)
    Item.user_pricings(user)
  end

  private
  def create_default_pricings_data
    User.all.each do |_user|
      ItemPricing.create(item: self, user: _user, price: self.price)
    end
  end
end