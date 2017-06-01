# frozen_string_literal: true
module Graph
  module Mutations
    RootMutation = GraphQL::ObjectType.define do
      name 'RootMutation'
      description 'The mutation root'

      field :addComment, field: Graph::Mutations::Comments::AddComment
    end
  end
end
