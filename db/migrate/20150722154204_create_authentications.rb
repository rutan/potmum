class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider, null: false, limit: 32
      t.string :uid, null: false, limit: 128

      t.timestamps null: false
    end
    add_index :authentications, [:provider, :uid], unique: true
  end
end
