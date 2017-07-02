class AddColumnToTags < ActiveRecord::Migration[5.1]
  def up
    add_column :tags, :key, :string, limit: 128

    TempTag.find_each do |tag|
      tag.update_columns(key: SecureRandom.uuid.remove('-'))
    end

    add_index :tags, :key, unique: true
  end

  def down
    remove_column :tags, :key
  end

  class TempTag < ActiveRecord::Base
    self.table_name = :tags
  end
end
