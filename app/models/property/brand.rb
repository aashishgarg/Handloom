class Property::Brand < ApplicationRecord

  # ===================== Associations ====================== #
  has_many :item_variants
end
