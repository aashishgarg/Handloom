ActiveAdmin.register Category do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  # =========== Permitted parameters =============================== #
  permit_params :name, :parent_id

  # =========== Scope for index page =============================== #
  scope :all_categories
  scope :root_categories
  scope :sub_categories
  # scope :sub_categories, default: true    #=> Default selected scope in index page

  # =========== Custom Filters ===================================== #
  # filter :name

  # =========== Custom Form for categories(Edit/New) =============== #
  form do |f|
    f.inputs 'Categories and sub categories form' do
      f.semantic_errors
      f.input :parent_id, :label => 'Root category', as: :select,
              collection: Category.root_categories.collect { |category| [category.name, category.id] }
      f.input :name
    end
    f.actions
  end

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :name
    column :root_category
    actions
  end
end
