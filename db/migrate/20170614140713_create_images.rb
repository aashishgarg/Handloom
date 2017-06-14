class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.belongs_to  :item
      t.attachment  :avatar
      t.timestamps
    end
  end
end
