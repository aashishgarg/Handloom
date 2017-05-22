class ItemsController < ApplicationController

  before_action :set_item, only: [:item_variant]
  before_action :authenticate_user!

  def index
    @sub_category = if params[:sub_category]
                      Category.where(id: params[:sub_category]).take
                    else
                      Category.first.sub_categories.first
                    end
    @category = @sub_category.root_category
    @items = @sub_category.items.page(params[:page])
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