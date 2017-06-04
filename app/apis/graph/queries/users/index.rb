# frozen_string_literal: true
module Graph
  module Queries
    module Users
      Index = GraphQL::Field.define do |field|
        field.type -> { types[Types::User] }
        field.description 'Get users'

        field.argument :size, types.Int, 'get size', default_value: 10
        field.argument :page, types.Int, 'page', default_value: 1

        field.resolve Graph::Handler.new -> (_obj, args, _context) do
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max

          ::User.page(page).per(size).decorate
        end
      end
    end
  end
end
