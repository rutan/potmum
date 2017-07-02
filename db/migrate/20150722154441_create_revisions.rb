class CreateRevisions < ActiveRecord::Migration[4.2]
  def change
    create_table :revisions do |t|
      t.string :article_id, limit: 128
      t.text :body

      t.timestamps null: false
    end
    add_index :revisions, :article_id
  end
end
