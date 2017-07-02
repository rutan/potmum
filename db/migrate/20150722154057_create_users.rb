class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 32
      t.string :email
      t.integer :stock_count, null: false, default: 0

      t.timestamps null: false
    end
    add_index :users, :name, unique: true
    add_index :users, :stock_count
  end
end
