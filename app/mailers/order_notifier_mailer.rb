class OrderNotifierMailer < ApplicationMailer

  default from: 'DrawingView'

  def notify_order_info(order)
    @order = order
    mail to: order.user.email, subject: 'Kapoor Handlooms: Order placed successfully.', from: 'Kapoor Handlooms'
  end
end
