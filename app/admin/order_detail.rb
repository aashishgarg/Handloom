ActiveAdmin.register Order::Detail do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  actions :all, :except => [:new, :destroy]

  # =========== Custom Index page ================================== #
  index do
    # selectable_column
    # id_column
    column :header_id
    column :item_variant
    column :quantity
  end

end
