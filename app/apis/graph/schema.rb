# frozen_string_literal: true
module Graph
  Schema = GraphQL::Schema.define do
    query Graph::Queries::RootQuery
    mutation Graph::Mutations::RootMutation
    max_depth 7
    default_max_page_size 50
  end

  Schema.middleware << Graph::Middlewares::Decorator.new
end
