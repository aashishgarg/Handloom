class ItemPricing < ApplicationRecord

  # =================== Associations ===================== #
  belongs_to :item
  belongs_to :user
  has_one :category, through: :item

  # =================== Validation ======================= #
  validates_uniqueness_of :item_id, scope: :user_id
  validates :item_id, presence: true
  validates :user_id, presence: true

  # validates :price, presence: true, inclusion: {in: (1..999999)}

  def self.item_price(item, user)
    ItemPricing.where(item: item, user: user).take
  end
end
