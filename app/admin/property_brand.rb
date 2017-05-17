ActiveAdmin.register Property::Brand do
  before_filter :only => :index do
    @skip_sidebar = true
  end

  permit_params :name

  controller do
    def create
      all_values = []
      all_values = params[:property_brand][:name].split(',') if params[:property_brand][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Brand.where(name: value).take
            Property::Brand.create(name: value)
          end
        end
      end

      redirect_to admin_property_brands_path
    end

    def update
      all_values = []
      all_values = params[:property_brand][:name].split(',') if params[:property_brand][:name]
      all_values.map!(&:strip)
      if all_values.present?
        all_values.each do |value|
          unless Property::Brand.where(name: value).take
            Property::Brand.create(name: value)
          end
        end
      end

      redirect_to admin_property_brands_path
    end
  end

end
