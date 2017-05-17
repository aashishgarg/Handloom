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
      link_to order.header_id, admin_order_header_path(order.header_id)
    end
    column :item_variant
    column :quantity
  end

end
