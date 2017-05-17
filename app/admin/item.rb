ActiveAdmin.register Item do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  # =========== Permitted parameters =============================== #
  permit_params :name, :category_id, :old_style_no, :new_style_no, :description,
                :short_description, :sku, :delivery_time, :meta_keywords, :meta_description

  # =========== Filters ============================================ #
  # filter ''

  # =========== Custom Form for Item(Edit/New) ===================== #
  form do |f|
    f.inputs 'Item Form' do
      f.input :category, as: :select, collection: Category.sub_categories.collect { |x| [x.name, x.id] }
      f.input :name
      f.input :old_style_no
      f.input :new_style_no
      f.input :description
      f.input :short_description
      f.input :sku
      f.input :delivery_time
      f.input :meta_keywords
      f.input :meta_description
    end
    f.actions
  end

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :category
    column :name
    column :total_variants do |item|
      label item.item_variants.count
    end
    column :old_style_no
    column :new_style_no
    # column :description
    # column :short_description
    column :sku
    column :delivery_time
    # column :meta_keywords
    # column :meta_description
    actions
  end
end
