class Category < ApplicationRecord

  # =================== Associations ===================== #
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :root_category, class_name: 'Category', foreign_key: 'parent_id', optional: true

  has_many :items, inverse_of: :category, dependent: :destroy
  has_many :item_variants, through: :items
  # has_many :properties, through: :item_variants

  # =================== Scopes =========================== #
  scope :root_categories, -> { where(parent_id: nil) }
  scope :sub_categories, -> { where.not(parent_id: nil) }
  scope :all_categories, -> { }

  # =================== Validations ====================== #
  validates :name, presence: true, length: {minimum: 2, maximum: 150}

  # =================== Class methods ==================== #
  def self.grouped
    Category.sub_categories.order(updated_at: :desc).group_by { |category| category.root_category if category.parent_id }
  end
end
