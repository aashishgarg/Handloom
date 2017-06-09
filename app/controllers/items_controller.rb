class ItemsController < ApplicationController

  before_action :set_item, only: [:item_variant]
  before_action :authenticate_user!

  def index
    @items = if params[:sub_category]
               Category.where(id: params[:sub_category]).take.items
             else
               Rails.cache.read('first_category_items') ||
                   (Rails.cache.write('first_category_items', items = Category.default.items); items)
             end.page(params[:page])
  end

  def show
    @item = Item.where(id: params[:id]).take
    @cart = Cart.new
  end

  def item_variant
    @available_variants = @item.item_variants.select { |variant| variant.color.id.to_s == params[:color] }
  end

  private
  def set_item
    @item = Item.where(id: params[:id]).take
  end

end