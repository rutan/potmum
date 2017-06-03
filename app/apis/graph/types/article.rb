# frozen_string_literal: true
module Graph
  module Types
    Article = GraphQL::ObjectType.define do
      name 'Article'
      description 'A blog entry'

      field :id, types.String
      field :title, types.String
      field :publishType, types.String, property: :publish_type
      field :body, types.String do
        resolve -> (obj, _args, _context) do
          obj.newest_revision.body
        end
      end
      field :html, types.String do
        resolve -> (obj, _args, _context) do
          obj.newest_revision.markdown_html
        end
      end
      field :tags, types[Types::Tag] do
        resolve -> (obj, _args, _context) do
          obj.tags
        end
      end
      field :comments, types[Types::Comment] do
        resolve -> (obj, _args, _context) do
          obj.comments
        end
      end
      field :user, -> { Types::User }
    end
  end
end
