# frozen_string_literal: true

module Graph
  module Queries
    module Users
      Index = GraphQL::Field.define do |field|
        field.type -> { Connections::User }
        field.description 'Get users'

        field.resolve Graph::Handler.new ->(_obj, _args, _context) do
          ::User.all
        end
      end
    end
  end
end
