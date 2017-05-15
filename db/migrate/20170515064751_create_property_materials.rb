class CreatePropertyMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :property_materials do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
