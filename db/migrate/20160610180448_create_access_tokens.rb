class CreateAccessTokens < ActiveRecord::Migration[4.2]
  def change
    create_table :access_tokens do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :token_type, default: 0
      t.integer :permit_type, default: 0
      t.string :title, limit: 32
      t.string :token, limit: 128, null: false

      t.timestamps null: false
    end
    #add_index :access_tokens, :token, unique: true
  end
end
