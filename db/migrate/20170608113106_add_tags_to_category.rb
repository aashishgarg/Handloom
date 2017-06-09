class AddTagsToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :latest, :boolean, after: :parent_id
    add_column :categories, :best_seller, :boolean, after: :latest
  end
end
