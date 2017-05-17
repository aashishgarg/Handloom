class Property::Size < ApplicationRecord

  # ===================== Associations ====================== #
  has_many :item_variants

  # ===================== Validations ======================= #
  validates :name, presence: true, length: {minimum: 2, maximum: 30}
end