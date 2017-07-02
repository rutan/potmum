# frozen_string_literal: true
module Graph
  module Types
    Tag = GraphQL::ObjectType.define do
      name 'Tag'
      description 'A tag'

      implements GraphQL::Relay::Node.interface

      field :id, !types.ID, property: :uuid
      field :objectId, types.Int, property: :id

      field :name, types.String
      field :code, types.String, property: :content
      field :isMenu, types.Boolean, property: :is_menu
      field :articleCount, types.Int, property: :article_count

      connection :articles, -> { Connections::Article } do
        resolve Graph::Handler.new -> (obj, _args, context) do
          obj.articles.public_or_mine(context[:access_token].try(:user))
        end
      end
    end
  end
end
