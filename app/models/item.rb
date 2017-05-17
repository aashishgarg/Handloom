class Item < ApplicationRecord

  # =================== Associations ===================== #
  belongs_to :category
  has_many :item_variants, inverse_of: :item, dependent: :destroy

  has_many :colors, class_name: 'Property::Color', through: :item_variants
  has_many :brands, class_name: 'Property::Brand', through: :item_variants
  has_many :sizes, class_name: 'Property::Size', through: :item_variants
  has_many :materials, class_name: 'Property::Material', through: :item_variants
end