# frozen_string_literal: true
module Graph
  module Queries
    module Articles
      Show = GraphQL::Field.define do |field|
        field.type -> { Types::Article }
        field.description 'Get an article'

        field.argument :id, types.String

        field.resolve Graph::Handler.new -> (_obj, args, context) do
          ::Article.find(args[:id]).tap do |article|
            Pundit.authorize(context[:access_token], article, :show?)
          end
        end
      end
    end
  end
end
