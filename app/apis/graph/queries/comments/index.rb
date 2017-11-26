# frozen_string_literal: true

module Graph
  module Queries
    module Comments
      Index = GraphQL::Field.define do |field|
        field.type -> { Connections::Comment }
        field.description 'Get comments'

        field.argument :order, types.String, default_value: 'desc'

        ORDER_TYPES = %w[asc desc].freeze

        field.resolve Graph::Handler.new ->(_obj, args, _context) do
          order = args[:order]
          raise GraphQL::ExecutionError, 'Invalid order format' unless ORDER_TYPES.include?(order)

          ::Comment.recent.except(:order).order(created_at: order)
        end
      end
    end
  end
end
