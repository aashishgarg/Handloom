class Property::Material < ApplicationRecord

  # ===================== Associations ====================== #
  has_many :item_variants
end
