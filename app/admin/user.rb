ActiveAdmin.register User do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  permit_params :email, :name, :phone, :address, :password, :password_confirmation



  # =========== Custom Form for Item(Edit/New) ===================== #
  form do |f|
    f.inputs 'User Form' do
      f.input :name
      f.input :email
      f.input :phone
      f.input :address
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :address
    column 'Total orders' do |user|
      label user.order_headers.count
    end
    column 'Last order' do |user|
      label user.order_headers.last.created_at if user.order_headers.present?
    end
    actions
  end

end
