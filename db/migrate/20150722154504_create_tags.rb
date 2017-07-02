class CreateTags < ActiveRecord::Migration[4.2]
  def change
    create_table :tags do |t|
      t.string :name, null: false, limit: 64
      t.string :content, null: false, limit: 64
      t.integer :article_count, null: false, default: 0
      t.boolean :is_menu, default: false

      t.timestamps null: false
    end
    add_index :tags, :content, unique: true
    add_index :tags, :article_count
    add_index :tags, :is_menu
  end
end
