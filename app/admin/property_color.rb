ActiveAdmin.register Property::Color do
  menu label: 'Colors', priority: 3, parent: 'Item Attributes'

  before_filter :only => :index do
    @skip_sidebar = true
  end

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column 'Total Items' do |property|
      label ItemVariant.where(color: property).count
    end
    column :created_at do |property|
      time_ago_in_words(property.created_at) + ' ago'
    end
    actions
  end

  controller do
    def create
      all_values = []
      all_values = params[:property_color][:name].split(',') if params[:property_color][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Color.where(name: value).take
            Property::Color.create(name: value)
          end
        end
      end

      redirect_to admin_property_colors_path
    end

    def update
      all_values = []
      all_values = params[:property_color][:name].split(',') if params[:property_color][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Color.where(name: value).take
            Property::Color.create(name: value)
          end
        end
      end

      redirect_to admin_property_colors_path
    end
  end

end
