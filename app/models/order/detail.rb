class Order::Detail < ApplicationRecord

  # ====================== Associations ==================== #
  belongs_to :order_header, class_name: 'Order::Header'
  belongs_to :item_variant

end
