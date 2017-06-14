# frozen_string_literal: true
module Graph
  module Types
    Revision = GraphQL::ObjectType.define do
      name 'Revision'
      description 'A revision of a blog entry'

      field :id, types.String
      field :title, types.String
      field :revisionType, types.String, property: :revision_type
      field :body, types.String
      field :note, types.String
      field :tagsText, types.String, property: :tags_text
      field :publishedAt, types.Int do
        resolve -> (obj, _args, _context) { obj.published_at ? obj.published_at.to_i : nil }
      end
      field :html, types.String, property: :markdown_html
      field :user, -> { Types::User }
      field :article, -> { Types::Article }
    end
  end
end
