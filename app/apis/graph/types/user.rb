# frozen_string_literal: true
module Graph
  module Types
    User = GraphQL::ObjectType.define do
      name 'User'
      description 'A user'

      field :id, types.Int
      field :name, types.String
      field :url, types.String
      field :avatarURL, types.String, property: :avatar_url
      field :stockCount, types.Int, property: :stock_count
    end
  end
end
