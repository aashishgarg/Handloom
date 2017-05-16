class UsersController < ApplicationController


  def cart
    # ----------- For adding item to cart for user ---------------- #
    if request.post?
      @cart_item = Cart.where(item_variant_id: params[:cart][:item_variant_id]).take
      if @cart_item
        @cart_item.update(quantity: (@cart_item.quantity.to_i + params[:cart][:quantity].to_i))
      else
        Cart.create(item_variant_id: params[:cart][:item_variant_id], quantity: params[:cart][:quantity], user_id: current_user.id)
        flash[:notice] = 'Item successfully added to the cart.'
      end
      # ----------- For showing user cart ---------------- #
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
    if @order
      flash[:notice] = 'Thanks! Your order is placed successfully. You will receive the order summary on your registered email.'
    end
    redirect_to items_path
  end

  private
  def order_params
    params.require(:order_header).permit(:id, order_details_attributes: [:item_variant_id, :quantity])
  end
end