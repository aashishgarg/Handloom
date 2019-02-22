ActiveAdmin.register Property::Size do
  menu label: 'Sizes',priority: 4, parent: 'Item Attributes'

  config.per_page = 10

  before_action :only => :index do
    @skip_sidebar = true
  end

  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column 'Total Items' do |property|
      label ItemVariant.where(size: property).count
    end
    column :created_at do |property|
      time_ago_in_words(property.created_at) + ' ago'
    end
  end

  controller do
    def create
      all_values = []
      all_values = params[:property_size][:name].split(',') if params[:property_size][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Size.where(name: value).take
            Property::Size.create(name: value)
          end
        end
      end

      redirect_to admin_property_sizes_path
    end

    def update
      all_values = []
      all_values = params[:property_size][:name].split(',') if params[:property_size][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Size.where(name: value).take
            Property::Size.create(name: value)
          end
        end
      end

      redirect_to admin_property_sizes_path
    end
  end

end
