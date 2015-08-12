class AddColumnToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :publish_type, :integer, default: 0
    add_index :articles, :publish_type

    TempArticle.find_each do |article|
      article.update_column(:publish_type, article.published_at ? 2 : 0)
    end
  end

  def down
    remove_column :articles, :publish_type
    remove_index :articles, :publish_type
  end

  class TempArticle < ActiveRecord::Base
    self.table_name = :articles
  end
end
