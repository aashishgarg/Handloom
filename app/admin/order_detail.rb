ActiveAdmin.register Order::Detail do

  menu priority: 10, label: 'Order Items', parent: 'Sales'

  config.per_page = 10

  # =========== Resource Actions =================================== #
  actions :all, :except => [:new, :destroy]

  # =========== Scopes ============================================= #
  scope('Filtered', default: true) { |scope| params[:bill_id] ? scope.where(header_id: params[:bill_id]) : scope.today }
  scope(Date.today.strftime '%A'){|scope| scope.where('Date(created_at) = (?)', Date.today)}
  scope :week
  scope :month
  scope :year
  scope :all

  # =========== Custom Filters ===================================== #
  # filter :order_header_bill_no_cont
  # filter :order_header_bill_no_eq, as: :select, collection: Order::Header.all.collect(&:bill_no)
  # filter :order_header_user_name_eq, as: :select, collection: User.all.collect(&:name)

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
    column :sku do |order|
      label order.item_variant.sku if order.item_variant
    end
    column :sku, label: 'Style no' do |order|
      label order.item_variant.new_style_no if order.item_variant
    end
    column :quantity
    column :color do |order|
      label order.item_variant.color.name if order.item_variant
    end
    column :size do |order|
      label order.item_variant.size.name if order.item_variant
    end
    column :image do |order|
      image_tag order.item.item_variants.first.item_image, class: 'item_image' if order.item_variant
    end
    column :created_at do |order|
      time_ago_in_words(order.created_at) + ' ago'
    end
  end

  # =========== Customized CSV Format ============================== #
  csv do
    column :id
    column(:item) { |order| order.item_variant.item.name }
    column(:sku) { |order| order.item_variant.sku }
    column(:style_no) { |order| order.item_variant.new_style_no }
    column(:color) { |order| order.item_variant.color.name }
    column(:size) { |order| order.item_variant.size.name }
    column(:material) { |order| order.item_variant.material.name if order.item_variant.material }
    column(:brand) { |order| order.item_variant.brand.name if order.item_variant.brand }
    column :quantity
    column(:bill_no) { |order| order.order_header.bill_no }
    column(:customer_name) { |order| order.order_header.user.name.capitalize }
    column(:customer_email) { |order| order.order_header.user.email }
    column(:created_at) { |order| order.created_at }
  end
end
