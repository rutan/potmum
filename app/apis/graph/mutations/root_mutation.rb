# frozen_string_literal: true
module Graph
  module Mutations
    RootMutation = GraphQL::ObjectType.define do
      name 'RootMutation'
      description 'The mutation root'

      field :addComment, field: Graph::Mutations::Comments::AddComment.field

      field :addStock, field: Graph::Mutations::Stocks::AddStock.field
      field :removeStock, field: Graph::Mutations::Stocks::RemoveStock.field
    end
  end
end
