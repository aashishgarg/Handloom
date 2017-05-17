class CreateOrderHeaders < ActiveRecord::Migration[5.0]
  def change
    create_table :order_headers do |t|
      t.integer :user_id
      t.string :bill_no
      t.string :status, default: 'open'

      t.timestamps
    end
  end
end
