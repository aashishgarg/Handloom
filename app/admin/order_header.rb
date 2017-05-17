ActiveAdmin.register Order::Header do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  actions :all, :except => [:new]

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :user
    column :created_at
  end

end
