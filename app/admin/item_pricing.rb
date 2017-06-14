ActiveAdmin.register ItemPricing do

  # ----------= Pagination ----------------------------------------- #
  config.per_page = 10

  # ----------= Permitted parameters ------------------------------- #
  permit_params :item_id, :user_id, :price

  actions :all, :except => [:new, :destroy]

  # =========== Custom Filters ===================================== #
  filter :user
  filter :category

  # --------------- Custom Form for Item Pricing(Edit/New) --------- #
  form do |f|
    f.inputs 'Item variant Form' do
      f.input :item, as: :select2, collection: Item.all.collect { |item| item.sku + ' | ' + item.new_style_no }
      f.input :user, as: :select2, collection: User.all.collect { |user| user.name+'('+user.email+')' }, label: 'Customer'
      f.input :price
    end
    f.actions
  end

  index do
    id_column
    column :item do |item_price|
      item_price.item.name
    end
    column :item, label: 'Sku' do |item_price|
      label item_price.item.sku
    end
    column :item, label: 'Style no' do |item_price|
      label item_price.item.new_style_no
    end
    column :user do |item_price|
      label item_price.user.name + ' ('+item_price.user.email+')'
    end
    column :price do |item_price|
      best_in_place item_price, :price, as: :input, url: [:admin, item_price]
    end
  end
end