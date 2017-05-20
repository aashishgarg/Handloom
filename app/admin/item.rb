ActiveAdmin.register Item do
  # =========== Menu item settings ================================ #
  menu priority: 7, parent: 'Item Master'

  # =========== Show/Hide Filters ================================= #
  # before_filter :only => :index do
  #   @skip_sidebar = true
  # end

  # =========== Upload Settings =================================== #
  # active_admin_import validate: true,
  #                     before_batch_import: proc { |import|
  #                       # import.file #current file used
  #                       # import.resource #ActiveRecord class to import to
  #                       # import.options # options
  #                       # import.result # result before bulk iteration
  #                       # import.headers # CSV headers
  #                       # import.csv_lines #lines to import
  #                       # import.model #template_object instance
  #                     },
  #                     after_batch_import: proc { |import|
  #                       #the same
  #                     }

  # =========== Permitted parameters =============================== #
  permit_params :name, :category_id, :old_style_no, :new_style_no, :description,
                :short_description, :sku, :delivery_time, :meta_keywords, :meta_description

  # =========== Header Level actions =============================== #
  actions :all, :except => [:destroy]

  # =========== Custom Filters ===================================== #
  filter :category_name_cont

  # =========== Pagination ========================================= #
  config.per_page = 10

  # =========== Custom Form for Item(Edit/New) ===================== #
  form do |f|
    f.inputs 'Item Form' do
      f.input :category, as: :select2, collection: Category.sub_categories.collect { |x| [x.root_category.name+' ('+x.name+')', x.id] }
      f.input :name
      # f.input :old_style_no
      f.input :new_style_no
      f.input :description
      f.input :short_description
      f.input :sku
      f.input :delivery_time
      f.input :meta_keywords
      f.input :meta_description
      if controller.action_name == 'new'
        f.input :colors, as: :select2_multiple, collection: Property::Color.all.collect { |x| [x.name, x.id] }, multiple: true
        f.input :sizes, as: :select2_multiple, collection: Property::Size.all.collect { |x| [x.name, x.id] }, multiple: true
        f.input :materials, as: :select2, collection: Property::Material.all.collect { |x| [x.name, x.id] }
        f.input :brands, as: :select2, collection: Property::Brand.all.collect { |x| [x.name, x.id] }
      end
    end
    f.actions
  end

  # =========== Custom Index page ================================== #
  index do
    # selectable_column
    id_column
    column :name
    column :total_variants do |item|
      link_to item.item_variants.count, admin_item_variants_path(item_id: item.id)
    end
    # column :old_style_no
    column :new_style_no
    column :sku
    column :delivery_time
    column :category
    actions
  end

  # =========== Controller ========================================= #
  controller do
    def create
      @item = Item.new(permitted_params[:item])

      params[:item][:color_ids].each do |color_id|
        params[:item][:size_ids].each do |size_id|
          @item.item_variants.build(color_id: color_id, size_id: size_id, material_id: params[:item][:material_ids],
                                    brand_id: params[:item][:brand_ids]) unless (color_id=='' || size_id=='')
        end
      end
      @item.save
      redirect_to admin_items_path
    end
  end
end
