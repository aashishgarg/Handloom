class Item < ApplicationRecord

  # =================== Associations ===================== #
  belongs_to :category
  has_many :item_variants
end