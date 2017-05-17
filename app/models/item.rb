class Item < ApplicationRecord

  # attr_accessible :item_variants_attributes
  # =================== Associations ===================== #
  belongs_to :category
  has_many :item_variants, inverse_of: :item, dependent: :destroy
  accepts_nested_attributes_for :item_variants

  has_many :colors, class_name: 'Property::Color', through: :item_variants
  has_many :brands, class_name: 'Property::Brand', through: :item_variants
  has_many :sizes, class_name: 'Property::Size', through: :item_variants
  has_many :materials, class_name: 'Property::Material', through: :item_variants
end