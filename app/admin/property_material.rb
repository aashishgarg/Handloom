ActiveAdmin.register Property::Material do
  menu label: 'Materials', priority: 5, parent: 'Item Attributes'

  config.per_page = 10

  before_filter :only => :index do
    @skip_sidebar = true
  end

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column 'Total Items' do |property|
      label ItemVariant.where(material: property).count
    end
    column :created_at do |property|
      time_ago_in_words(property.created_at) + ' ago'
    end
  end

  controller do
    def create
      all_values = []
      all_values = params[:property_material][:name].split(',') if params[:property_material][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Material.where(name: value).take
            Property::Material.create(name: value)
          end
        end
      end

      redirect_to admin_property_materials_path
    end

    def update
      all_values = []
      all_values = params[:property_material][:name].split(',') if params[:property_material][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Material.where(name: value).take
            Property::Material.create(name: value)
          end
        end
      end

      redirect_to admin_property_materials_path
    end
  end

end
