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
                :short_description, :sku, :delivery_time, :meta_keywords, :meta_description, :price

  # =========== Header Level actions =============================== #
  actions :all, :except => [:destroy]

  # =========== Custom Filters ===================================== #
  filter :category

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
      f.input :price
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
    column :price, label: 'Default Price' do |item|
      best_in_place item, :price, as: :input, url: [:admin, item]
    end
    # column :delivery_time
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
      problematic_data = []

      # ------------------ Get CSV Data ------------------------------ #
      csv_data = CSV.read(params[:active_admin_import_model][:file].path)
      if csv_data.present?
        # --------- Strip all values ------------------------- #
        csv_data.each { |row| row.each { |row_item| row_item.strip! if row_item.respond_to? :strip! } }

        # --------- First row is considered to be header ----- #
        csv_data.delete(csv_data[0])

        csv_data.each_with_index do |data, index|
          # ------------------ Create Categories ------------------------- #
          category = Category.where(name: data[0]).take || Category.create(name: data[0])

          # ------------------ Create Sub Categories --------------------- #
          sub_category = (Category.where('name = (?) and parent_id = (?)', data[1], category.id).take) ||
              (Category.create(name: data[1], parent_id: category.id))

          @item = Item.new(
              category_id: sub_category.id,
              name: data[2],
              new_style_no: data[3],
              description: data[4],
              short_description: data[5],
              sku: data[6],
              delivery_time: data[7],
              meta_keywords: data[8],
              meta_description: data[9],
              price: data[10]
          )

          # ------------------ Materials --------------------------------- #
          material = Property::Material.where(name: data[13]).take || Property::Material.create(name: data[13])

          # ------------------ Brands ------------------------------------ #
          brand = Property::Brand.where(name: data[14]).take || Property::Brand.create(name: data[14])

          # ------------------ Colors ------------------------------------ #
          colors = data[11] || 'Custom color'

          colors.split('_').each do |_color|
            color = Property::Color.where(name: _color).take || Property::Color.create(name: _color)
            # ------------------ Sizes ------------------------------------- #
            sizes = data[12] || 'Custom size'
            sizes.split('_').each do |_size|
              size = Property::Size.where(name: _size).take || Property::Size.create(name: _size)
              # ------------------ Item Variant ------------------------------ #
              @item.item_variants.build(
                  color_id: color.id,
                  size_id: size.id,
                  material_id: material.id,
                  brand_id: brand.id
              )
            end
          end

          # ------------------ Product Image ----------------------------- #
          image_path = File.join('/home/deploy/product_images',data[6]).concat('.jpg')
          puts '**********************************************************************************'
          puts image_path
          puts '**********************************************************************************'

          @item.item_variants.first.image = File.open(image_path) if File.exist?(image_path)

          # ------------------ Item -------------------------------------- #
          unless @item.save
            problematic_data << data
            puts 'ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR'
            puts  @item.errors.full_messages
            puts 'ERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERRORERROR'
          end
        end
      end
      puts '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
      puts problematic_data.count
      puts '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
      puts problematic_data
      puts '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
    end


  end
end
