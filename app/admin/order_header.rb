ActiveAdmin.register Order::Header do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  actions :all, :except => [:new]

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :bill_no
    column :user do |order|
      label order.user.name.capitalize + ' ('+order.user.email+')'
    end
    column :total_items do |order|
      label order.order_details.count
    end
    column :created_at
  end

end
