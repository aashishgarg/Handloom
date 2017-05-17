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
      f.input :category, as: :select, collection: Category.sub_categories.collect { |x| [x.root_category.name+' ('+x.name+')', x.id] }
      f.input :name
      f.input :old_style_no
      f.input :new_style_no
      f.input :description
      f.input :short_description
      f.input :sku
      f.input :delivery_time
      f.input :meta_keywords
      f.input :meta_description

      # f.inputs "Item variants colors" do
      f.object.item_variants.build

      # f.fields_for :item_variants do |m|
      #   m.inputs do
      #     m.input :color_id, as: :text
      #   end
      # end
      #
      # f.fields_for :item_variants do |m|
      #   m.inputs do
      #     m.input :size_id, as: :select, collection: Property::Size.all.collect { |x| [x.name, x.id] }, multiple: true
      #   end
      # end
    end
    f.actions
  end

  # =========== Custom Index page ================================== #
  index do
    selectable_column
    id_column
    column :name
    column :total_variants do |item|
      label item.item_variants.count
    end
    column :old_style_no
    column :new_style_no
    column :sku
    column :delivery_time
    column :category
    actions
  end

  # =========== Controller ========================================= #

  # controller do
  #
  #   def create
  #
  #   end
  # end

end
