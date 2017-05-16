class Order::Header < ApplicationRecord

  # ====================== Associations ==================== #
  belongs_to :user

  has_many :order_details, class_name: 'Order::Detail'
  accepts_nested_attributes_for :order_details

  # ====================== Callbacks ======================= #
  after_create :clean_out_bucket
  after_create :notify_order_info


  def notify_order_info
    OrderNotifierMailer.notify_order_info(self).deliver_now
  end

  private
  def clean_out_bucket
    user.cart_items.delete_all
  end
end
