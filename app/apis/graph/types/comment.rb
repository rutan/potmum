# frozen_string_literal: true
module Graph
  module Types
    Comment = GraphQL::ObjectType.define do
      name 'Comment'
      description 'A comment of an article'

      implements GraphQL::Relay::Node.interface

      field :id, !types.ID, property: :uuid
      field :objectId, types.Int, property: :id
      field :body, types.String
      field :html, types.String do
        resolve -> (obj, _args, _context) do
          obj.markdown_html
        end
      end
      field :user, -> { Types::User }
      field :article, -> { Types::Article }
    end
  end
end
