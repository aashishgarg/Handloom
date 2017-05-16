class UsersController < ApplicationController

  def cart
    if request.post?
      @cart_item = Cart.where(item_variant_id: params[:cart][:item_variant_id]).take
      if @cart_item
        @cart_item.update(quantity: (@cart_item.quantity.to_i + params[:cart][:quantity].to_i))
      else
        Cart.create(item_variant_id: params[:cart][:item_variant_id], quantity: params[:cart][:quantity], user_id: current_user.id)
      end
    else
      @cart_items = Cart.all
      @order = Order::Header.new
      @order_details = @order.order_details.build
    end
  end

  def remove_cart_item
    @cart_item = Cart.where(id: params[:id]).take
    @cart_item.destroy
  end

  def order
    @order = Order::Header.create(order_params.merge(user: current_user))
  end

  private
  def order_params
    params.require(:order_header).permit(:id, order_details_attributes: [:item_variant_id, :quantity])
  end
end