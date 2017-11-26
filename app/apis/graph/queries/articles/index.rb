# frozen_string_literal: true

module Graph
  module Queries
    module Articles
      Index = GraphQL::Field.define do |field|
        field.type -> { Connections::Article }
        field.description 'Get articles'

        field.resolve Graph::Handler.new ->(_obj, _args, _context) do
          ::Article.public_items
        end
      end
    end
  end
end
