class Property::Material < ApplicationRecord

  # ===================== Associations ====================== #
  has_many :item_variants

  # ===================== Validations ======================= #
  validates :name, presence: true, length: {minimum: 2}
end
