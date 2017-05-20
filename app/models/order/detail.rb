class Order::Detail < ApplicationRecord

  # ====================== Associations ==================== #
  belongs_to :order_header, class_name: 'Order::Header', foreign_key: 'header_id'
  belongs_to :item_variant

  # ====================== Scopes ========================== #
  scope :today, -> { where(created_at: Date.today) }
  scope :week, -> { where('created_at >= (?)', (Date.today - 1.week)) }
  scope :month, -> { where('created_at >= (?)', (Date.today - 1.month)) }
  scope :year, -> { where('created_at >= (?)', (Date.today - 1.year)) }

end
