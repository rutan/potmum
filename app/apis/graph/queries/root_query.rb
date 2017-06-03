# frozen_string_literal: true
module Graph
  module Queries
    RootQuery = GraphQL::ObjectType.define do
      name 'RootQuery'
      description 'The query root'

      field :articles, field: Graph::Queries::Articles::Index
      field :article, field: Graph::Queries::Articles::Show
      field :search, field: Graph::Queries::Articles::Search

      field :user do
        type -> { Types::User }
        description 'Get a user'

        argument :id, types.Int

        resolve -> (_object, args, context) do
          ::User.find(args[:id]).tap do |user|
            Pundit.authorize(context[:access_token], user, :show?)
          end.decorate
        end
      end
    end
  end
end
