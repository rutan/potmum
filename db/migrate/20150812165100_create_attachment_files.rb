class CreateAttachmentFiles < ActiveRecord::Migration[4.2]
  def change
    create_table :attachment_files do |t|
      t.references :user, index: true, foreign_key: true
      t.string :file, limit: 128

      t.timestamps null: false
    end
    add_index :attachment_files, :file, unique: true
  end
end
