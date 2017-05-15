class Property::Color < ApplicationRecord

  # ===================== Associations ====================== #
  has_many :item_variants
end
