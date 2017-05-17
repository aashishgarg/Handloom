class Order::Detail < ApplicationRecord

  # ====================== Associations ==================== #
  belongs_to :order_header, class_name: 'Order::Header', foreign_key: 'header_id'
  belongs_to :item_variant

end
