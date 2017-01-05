# frozen_string_literal: true
module Graph
  module Types
    Tag = GraphQL::ObjectType.define do
      name 'Tag'
      description 'A tag'

      field :name, types.String
      field :code, types.String, property: :content
    end
  end
end
