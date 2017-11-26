# frozen_string_literal: true

module Graph
  module Queries
    RootQuery = GraphQL::ObjectType.define do
      name 'RootQuery'
      description 'The query root'

      field :node, GraphQL::Relay::Node.field

      connection :articles, field: Graph::Queries::Articles::Index
      connection :search, field: Graph::Queries::Articles::Search
      field :article, field: Graph::Queries::Articles::Show

      connection :users, field: Graph::Queries::Users::Index
      field :user, field: Graph::Queries::Users::Show

      connection :tags, field: Graph::Queries::Tags::Index
      field :tag, field: Graph::Queries::Tags::Show

      connection :comments, field: Graph::Queries::Comments::Index
      field :comment, field: Graph::Queries::Comments::Show
    end
  end
end
