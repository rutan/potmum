# frozen_string_literal: true
module Graph
  Schema = GraphQL::Schema.define do
    query Graph::Types::RootQuery
    max_depth 5
  end
end
