class CreateLinkArticleTags < ActiveRecord::Migration
  def change
    create_table :link_article_tags do |t|
      t.string :article_id, limit: 128
      t.integer :tag_id, null: false

      t.timestamps null: false
    end
    add_index :link_article_tags, [:article_id, :tag_id], unique: true
  end
end
