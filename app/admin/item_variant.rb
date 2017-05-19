ActiveAdmin.register ItemVariant do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  # =========== Permitted parameters =============================== #
  permit_params :item_id, :image, :price, :special_price, :color_id,:brand_id,:size_id,:material_id

  # =========== Filters ============================================ #
  # filter ''

  # =========== Custom Form for Item(Edit/New) ===================== #
  form do |f|
    f.inputs 'Item variant Form' do
      f.input :item, as: :select2, collection: Item.all.collect { |item| [item.name, item.id] }
      f.input :price
      f.input :special_price
      f.input :image, as: :file
      f.input :color, as: :select2
      f.input :size, as: :select2
      f.input :brand, as: :select2
      f.input :material, as: :select2
    end
    f.actions
  end

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :image do |item_variant|
      image_tag item_variant.item_image, class: 'item_image'
    end
    column :item do |item_variant|
      label item_variant.item.name
      link_to '('+item_variant.item.sku+') ', admin_item_path(item_variant.item)
    end
    column :price, sortable: true
    column :special_price, sortable: true
    column :color
    column :size
    column :brand
    column :material
    actions
  end
end
