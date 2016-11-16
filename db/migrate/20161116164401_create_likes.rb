class CreateLikes < ActiveRecord::Migration
  def up
    create_table :likes do |t|
      t.string :target_type, null: false
      t.string :target_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
    add_index :likes, [:target_type, :target_id, :user_id], unique: true
    add_column :articles, :like_count, :integer, default: 0
    add_index :articles, :like_count
    add_column :users, :like_count, :integer, default: 0
    add_index :users, :like_count

    TempStock.find_each do |stock|
      article = TempArticle.find_by(id: stock.article_id)
      user = TempUser.find_by(id: stock.user_id)
      next unless article && user
      TempLike.create!(
        target_type: 'Article',
        target_id: stock.article_id,
        user_id: stock.user_id
      )
      article.update_columns(like_count: article.like_count + 1)
      user.update_columns(like_count: user.like_count + 1)
    end
  end

  def down
    remove_column :articles, :like_count
    remove_column :users, :like_count
    drop_table :likes
  end

  class TempArticle < ActiveRecord::Base
    self.table_name = :articles
  end

  class TempUser < ActiveRecord::Base
    self.table_name = :users
  end

  class TempStock < ActiveRecord::Base
    self.table_name = :stocks
  end

  class TempLike < ActiveRecord::Base
    self.table_name = :likes
  end
end
