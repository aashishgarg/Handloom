class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.integer :category_id
      t.string :name
      t.string :old_style_no
      t.string :new_style_no
      t.text :description
      t.text :short_description
      t.string :sku
      t.string :delivery_time
      t.text :meta_keywords
      t.text :meta_description
      t.string :status, default: 'open'

      t.timestamps
    end
  end
end
