class ItemVariant < ApplicationRecord

  # ===================== Associations ====================== #
  belongs_to :item, inverse_of: :item_variants, required: true
  has_one :category, through: :item

  belongs_to :color, class_name: 'Property::Color', optional: true
  belongs_to :brand, class_name: 'Property::Brand', optional: true
  belongs_to :size, class_name: 'Property::Size', optional: true
  belongs_to :material, class_name: 'Property::Material', optional: true

  # ===================== Photofy =========================== #
  photofy :image

  # ===================== Delegates ======================== #
  delegate :name, :old_style_no, :new_style_no, :description, :short_description, :sku, :delivery_time, :meta_keywords,
           :meta_description,
           to: :item

  def item_image
    image? ? image_path.gsub(Rails.root.to_s, '') : 'sample_item.jpeg'
  end

  def properties
    [color, size, brand, material].compact.collect { |property| "#{property.class.name.demodulize.capitalize} - #{property.name.capitalize}" }
  end

  def properties_string
    properties.join(' | ')
  end
end