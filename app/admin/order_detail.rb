ActiveAdmin.register Order::Detail do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  actions :all, :except => [:new, :destroy]

  # =========== Custom Index page ================================== #
  index do
    # selectable_column
    id_column
    column 'Bill No', sortable: true do |order|
      link_to order.order_header.bill_no, admin_order_header_path(order.header_id)
    end
    column :item_variant
    column :quantity
    column :color do |order|
      label order.item_variant.color.name
    end
    column :size do |order|
      label order.item_variant.size.name
    end
    column :image do |order|
      image_tag order.item_variant.item_image, class: 'item_image'
    end
    column :created_at
  end

end
