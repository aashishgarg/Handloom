class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sub_category = if params[:sub_category]
                      Category.where(id: params[:sub_category]).take
                    else
                      Category.first.sub_categories.first
                    end
    @category = @sub_category.root_category
  end

  def show
    @item = Item.where(id: params[:id]).take
  end
end