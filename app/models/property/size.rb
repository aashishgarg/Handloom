class Property::Size < ApplicationRecord

  # ===================== Associations ====================== #
  has_many :item_variants
end