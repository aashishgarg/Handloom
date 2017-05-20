ActiveAdmin.register Order::Detail do
  # belongs_to :order_header, class: 'Order::Header'
  # before_filter :only => :index do
  #   @skip_sidebar = true
  # end

  actions :all, :except => [:new, :destroy]

  # =========== Custom Filters ===================================== #
  filter :order_header_bill_no_cont
  filter :order_header_user_name_cont

  # =========== Pagination ========================================= #
  config.per_page = 10

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
      label order.item_variant.color.name if order.item_variant
    end
    column :size do |order|
      label order.item_variant.size.name if order.item_variant
    end
    column :image do |order|
      image_tag order.item_variant.item_image, class: 'item_image' if order.item_variant
    end
    column :created_at do |order|
      time_ago_in_words(order.created_at) + ' ago'
    end
  end

end
