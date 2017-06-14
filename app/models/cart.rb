class Cart < ApplicationRecord

  # ======================= Associations ===================== #
  belongs_to :user
  belongs_to :item_variant
  has_one :item, through: :item_variant


  def self.total_items
    Cart.count
  end

  def self.total_quantity
    Cart.all.collect(&:quantity).inject(&:+) || 0
  end
end
