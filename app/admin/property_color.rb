ActiveAdmin.register Property::Color do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  permit_params :name

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
