# frozen_string_literal: true
module Graph
  module Types
    SearchResult = GraphQL::ObjectType.define do
      name 'Search'
      description 'A result of article search'

      field :totalCount, types.Int, property: :total_count
      field :articles, types[Types::Article]
    end
  end
end
