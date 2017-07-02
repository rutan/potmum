class AddColumnToComments < ActiveRecord::Migration[5.1]
  def up
    add_column :comments, :key, :string, limit: 128

    TempComment.find_each do |comment|
      comment.update_columns(key: SecureRandom.uuid.remove('-'))
    end

    add_index :comments, :key, unique: true
  end

  def down
    remove_column :comments, :key
  end

  class TempComment < ActiveRecord::Base
    self.table_name = :comments
  end
end
