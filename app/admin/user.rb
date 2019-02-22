ActiveAdmin.register User do
  menu priority: 1

  config.per_page = 10

  before_action :only => :index do
    @skip_sidebar = true
    @users = User.where.not('email in (?)', User::ADMIN_EMAILS).page(params[:page])
  end

  # =========== Header Level actions =============================== #
  actions :all, :except => [:destroy]

  # =========== Permitted Parameters =============================== #
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
    # selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :address
    column 'Total orders' do |user|
      label user.order_headers.count
    end
    column 'Last order' do |user|
      label time_ago_in_words(user.order_headers.last.created_at) + ' ago' if user.order_headers.present?
    end
    column 'Last sign in' do |user|
      label user.current_sign_in_at ? time_ago_in_words(user.current_sign_in_at) + ' ago' : ''
    end
    column 'sign in count' do |user|
      label user.sign_in_count
    end
    actions
  end

end
