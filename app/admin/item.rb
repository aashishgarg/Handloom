ActiveAdmin.register Item do
  # =========== Menu item settings ================================ #
  menu priority: 7, parent: 'Item Master'

  # =========== Show/Hide Filters ================================= #
  # before_filter :only => :index do
  #   @skip_sidebar = true
  # end

  # =========== Upload Settings =================================== #
  active_admin_import validate: true

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

    def do_import
      csv_data = CSV.read(params[:active_admin_import_model][:file].path)
      csv_data.each_with_index do |data, index|

        if index > 0 #--> For leaving the headers
          category = Category.where(name: data[0].strip).take

          @item = Item.new(category_id: (!!category ? category.id : nil),
                           name: data[1].strip,
                           new_style_no: data[2].strip,
                           description: data[3].strip,
                           short_description: data[4].strip,
                           sku: data[5].strip,
                           delivery_time: data[6].strip,
                           meta_keywords: data[7].strip,
                           meta_description: data[8].strip
          )

          material = if Property::Material.where(name: data[11].strip).take
                       Property::Material.where(name: data[11].strip).take
                     else
                       Property::Material.create(name: data[11].strip)
                     end

          brand = if Property::Brand.where(name: data[12].strip).take
                    Property::Brand.where(name: data[12].strip).take
                  else
                    Property::Brand.create(name: data[12].strip)
                  end


          data[9].split('_').each do |color|
            Property::Color.create(name: color.strip) unless Property::Color.where(name: color.strip).take
            color_id = Property::Color.where(name: color.strip).take.id
            data[10].split('_').each do |size|
              Property::Size.create(name: size.strip) unless Property::Size.where(name: size.strip).take

              size_id = Property::Size.where(name: size.strip).take.id
              unless color_id=='' || size_id=='' || brand =='' || material ==''
                @item.item_variants.build(
                    color_id: color_id,
                    size_id: size_id,
                    material_id: material.id,
                    brand_id: brand.id
                )
              end
            end
          end
          @item.save
        end
      end
    end
  end
end
