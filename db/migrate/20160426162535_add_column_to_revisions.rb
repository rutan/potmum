class AddColumnToRevisions < ActiveRecord::Migration
  def up
    add_column :revisions, :title, :string, default: ''
    add_column :revisions, :tags_text, :text, default: ''
    add_column :revisions, :user_id, :integer
    add_column :revisions, :published_at, :timestamp, default: nil, null: true
    add_column :revisions, :revision_type, :integer, default: 0
    add_column :revisions, :note, :text, null: true
    add_index :revisions, :user_id
    add_index :revisions, :published_at
    add_index :revisions, :revision_type

    TempArticle.includes(:newest_revision).find_each do |article|
      next unless article.newest_revision
      article.newest_revision.update_columns(
        revision_type: article.published_at ? 2 : 1,
        published_at: article.published_at ? article.published_at : article.updated_at,
      )
    end

    TempRevision.includes(:article).find_each do |revision|
      next unless revision.article
      article = revision.article
      revision.update_columns(
        user_id: article.user_id,
        title: article.title,
        tags_text: '',
        note: '',
        published_at: article.published_at ? article.published_at : article.updated_at,
      )
    end
  end

  def down
    remove_column :revisions, :title
    remove_column :revisions, :tags_text
    remove_column :revisions, :user_id
    remove_column :revisions, :published_at
    remove_column :revisions, :revision_type
    remove_column :revisions, :note
  end

  class TempArticle < ActiveRecord::Base
    self.table_name = :articles
    belongs_to :newest_revision, class_name: 'TempRevision'
  end

  class TempRevision < ActiveRecord::Base
    self.table_name = :revisions
    belongs_to :article, class_name: 'TempArticle'
  end
end
