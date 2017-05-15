class ItemVariant < ApplicationRecord

  # ===================== Associations ====================== #
  belongs_to :item, inverse_of: :item_variants, required: true

  belongs_to :color, class_name: 'Property::Color', optional: true
  belongs_to :brand, class_name: 'Property::Brand', optional: true
  belongs_to :size, class_name: 'Property::Size', optional: true
  belongs_to :material, class_name: 'Property::Material', optional: true

  # ===================== Photofy =========================== #
  photofy :image


  def item_image
    image? ? image_path.gsub(Rails.root.to_s, '') : 'sample_item.jpeg'
  end
end