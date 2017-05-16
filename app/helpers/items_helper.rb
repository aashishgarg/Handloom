module ItemsHelper

  def cart_item_variant(variant_id)
    ItemVariant.where(id: variant_id).take
  end
end
