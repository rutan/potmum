# frozen_string_literal: true
module Graph
  module Queries
    module Tags
      Index = GraphQL::Field.define do |field|
        field.type -> { Connections::Tag }
        field.description 'Get tags'

        field.argument :sort, types.String, default_value: 'articleCount'
        field.argument :order, types.String, default_value: 'desc'
        field.argument :filter, types[types.String]

        SORT_TYPES = %w(name articleCount).freeze
        ORDER_TYPES = %w(asc desc).freeze

        field.resolve Graph::Handler.new -> (_obj, args, _context) do
          sort = args[:sort]
          order = args[:order]
          filter = args[:filter] || []
          raise GraphQL::ExecutionError, 'Invalid sort format' unless SORT_TYPES.include?(sort)
          raise GraphQL::ExecutionError, 'Invalid order format' unless ORDER_TYPES.include?(order)

          tags = ::Tag.enabled
                      .except(:order).order(sort.underscore => order)

          tags = tags.where(is_menu: true) if filter.include?('isMenu')

          tags
        end
      end
    end
  end
end
