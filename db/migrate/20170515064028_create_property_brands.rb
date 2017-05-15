class CreatePropertyBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :property_brands do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
