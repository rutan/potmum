class CreateArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :articles, id: false do |t|
      t.column :id, 'VARCHAR(128) PRIMARY KEY NOT NULL' # ✝闇✝
      t.references :user, index: true, foreign_key: true
      t.string :title, limit: 128
      t.integer :newest_revision_id, null: true
      t.integer :view_count, null: false, default: 0
      t.integer :stock_count, null: false, default: 0
      t.integer :comment_count, null: false, default: 0

      t.timestamps null: false
      t.timestamp :published_at, null: true
    end
    add_index :articles, :id, unique: true
    add_index :articles, :view_count
    add_index :articles, :stock_count
    add_index :articles, :comment_count
    add_index :articles, :created_at
    add_index :articles, :published_at
  end
end
