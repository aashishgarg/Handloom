class UsersController < ApplicationController
  before_action :set_item, only: [:cart]

  def cart
    # ----------- For adding item to cart for user ---------------- #
    if request.post?
      if @item_variant
        @cart_item = Cart.where(item_variant_id: @item_variant.id).take
        if @cart_item
          @cart_item.update(quantity: (@cart_item.quantity.to_i + params[:cart][:quantity].to_i))
        else
          Cart.create(item_variant_id: @item_variant.id, quantity: params[:cart][:quantity], user_id: current_user.id)
          flash[:notice] = 'Item successfully added to the cart.'
        end
      else
        flash[:error] = 'Color and Size selection is mandatory for adding an item to cart.'
      end

      # ----------- For showing user cart ---------------- #
    else
      @order = Order::Header.new
      @order_details = @order.order_details.build
    end
    @cart_items = current_user.cart_items
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

  def set_item
    if request.post?
      @item = Item.where(id: params[:item_id]).take
      @item_variant = @item.item_variants.where(color_id: params[:color].to_i, size_id: params[:size].to_i).take
    end
  end
end