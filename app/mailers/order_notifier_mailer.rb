class OrderNotifierMailer < ApplicationMailer

  default from: 'DrawingView'

  def notify_order_info(order)
    @order = order
    mail to: order.user.email, subject: 'KapoorExports: Order places successfully.'
  end
end
