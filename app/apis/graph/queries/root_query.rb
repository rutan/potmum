# frozen_string_literal: true
module Graph
  module Queries
    RootQuery = GraphQL::ObjectType.define do
      name 'RootQuery'
      description 'The query root'

      field :articles, field: Graph::Queries::Articles::Index
      field :article, field: Graph::Queries::Articles::Show
      field :search, field: Graph::Queries::Articles::Search

      field :users, field: Graph::Queries::Users::Index
      field :user, field: Graph::Queries::Users::Show
    end
  end
end
