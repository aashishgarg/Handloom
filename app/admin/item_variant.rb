ActiveAdmin.register ItemVariant do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  # =========== Permitted parameters =============================== #
  permit_params :item_id, :image, :price, :special_price

  # =========== Filters ============================================ #
  # filter ''

  # =========== Custom Form for Item(Edit/New) ===================== #
  # form do |f|
  #   f.inputs 'Item variant Form' do
  #     f.input :item, as: :select, collection: Item.all.collect { |item| [item.name, item.id] }
  #     f.input :price
  #     f.input :special_price
  #     f.input :image, as: :file
  #     # Property.all.collect(&:name).uniq.each do |name|
  #     #   f.input :properties, as: :check_boxes, collection: Property.where(name: name).collect { |p| [p.value, p.id] }
  #     # end
  #   end
  #   f.actions
  # end

  # =========== Custom Index page ================================== #
  # index do
  #   selectable_column
  #   id_column
  #   column :image do |item_variant|
  #     image_tag item_variant.item_image, class: 'item_image'
  #   end
  #   column :item
  #   column :price
  #   column :special_price
  #
  #   # Property.all.collect(&:name).uniq.each do |name|
  #   #   column name do |item_variant|
  #   #     properties = item_variant.properties.send(name.to_s.pluralize)
  #   #     properties.first.value if properties.present?
  #   #   end
  #   # end
  #   actions
  # end
end
