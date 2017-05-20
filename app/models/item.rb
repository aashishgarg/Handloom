class Item < ApplicationRecord

  # =================== Associations ===================== #
  belongs_to :category
  has_many :item_variants, inverse_of: :item, dependent: :destroy

  has_many :colors, class_name: 'Property::Color', through: :item_variants
  has_many :brands, class_name: 'Property::Brand', through: :item_variants
  has_many :sizes, class_name: 'Property::Size', through: :item_variants
  has_many :materials, class_name: 'Property::Material', through: :item_variants

  # =================== Validations ====================== #
  validates :name, presence: true, length: {minimum: 2, maximum: 50}
  validates :description, presence: true, length: {minimum: 2}
  validates :sku, presence: true, length: {minimum: 2, maximum: 50}
  validates :new_style_no, presence: true, length: {minimum: 2, maximum: 50}

  # =================== Pagination ======================= #
  # paginates_per 3
end