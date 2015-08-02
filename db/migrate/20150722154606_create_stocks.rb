class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :article_id, null: false, limit: 128
      t.integer :user_id, null: false

      t.timestamps null: false
    end
    add_index :stocks, [:article_id, :user_id], unique: true
    add_index :stocks, :created_at
  end
end
