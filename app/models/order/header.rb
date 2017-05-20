class Order::Header < ApplicationRecord

  # ====================== Associations ==================== #
  belongs_to :user

  has_many :order_details, class_name: 'Order::Detail'
  accepts_nested_attributes_for :order_details

  # ====================== Callbacks ======================= #
  after_create :save_bill_no
  after_create :clean_out_bucket
  after_create :notify_order_info

  # ====================== Scopes ========================== #
  scope :today, -> { where(created_at: Date.today) }
  scope :week, -> { where('created_at >= (?)', (Date.today - 1.week)) }
  scope :month, -> { where('created_at >= (?)', (Date.today - 1.month)) }
  scope :year, -> { where('created_at >= (?)', (Date.today - 1.year)) }

  def notify_order_info
    OrderNotifierMailer.notify_order_info(self).deliver_later
  end

  def bill_no
    date = Date.today.day.to_s.rjust(2, '0')
    month = Date.today.month.to_s.rjust(2, '0')
    year = Date.today.year.to_s.rjust(4, '0')
    customer = 'CUS'+ user.id.to_s.rjust(5, '0')
    bill = 'BILL'+ id.to_s.rjust(5, '0')

    date + month + year + customer + bill
  end

  private
  def clean_out_bucket
    user.cart_items.delete_all
  end

  def save_bill_no
    update(bill_no: self.bill_no)
  end
end
