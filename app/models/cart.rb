class Cart < ApplicationRecord

  # ======================= Associations ===================== #
  belongs_to :user


  def self.total_items
    Cart.count
  end

  def self.total_quantity
    Cart.all.collect(&:quantity).inject(&:+)
  end
end
