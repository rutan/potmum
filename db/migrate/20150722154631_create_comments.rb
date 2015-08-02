class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :article_id, null: false, limit: 128
      t.references :user, index: true, foreign_key: true
      t.text :body

      t.timestamps null: false
    end
    add_index :comments, :article_id
    add_index :comments, :created_at
  end
end
