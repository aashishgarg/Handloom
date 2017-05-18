ActiveAdmin.register Order::Header do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  actions :all, :except => [:new]

  # =========== Custom Filters ===================================== #
  filter :bill_no

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :bill_no do |order|
      link_to order.bill_no, admin_order_header_path(order)
    end
    column :user do |order|
      label order.user.name.capitalize + ' ('+order.user.email+')'
    end
    column :total_items do |order|
      label order.order_details.count
    end
    column :total_quantity do |order|
      label order.order_details.collect(&:quantity).inject(&:+)
    end
    column :created_at do |order|
      time_ago_in_words(order.created_at) + ' ago'
    end
  end

  # show do
  #   render 'show'
  # end

end
