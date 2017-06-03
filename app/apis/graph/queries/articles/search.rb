# frozen_string_literal: true
module Graph
  module Queries
    module Articles
      Search = GraphQL::Field.define do |field|
        field.type -> { Types::SearchResult }
        field.description 'Search articles'

        field.argument :query, types.String, 'search query'
        field.argument :size, types.Int, 'get size', default_value: 10
        field.argument :page, types.Int, 'page', default_value: 1

        field.resolve Graph::Handler.new -> (_obj, args, context) do
          query = args[:query]
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max

          ::SearchArticleService.new.call(
            access_token: context[:access_token],
            query: query,
            page: page,
            size: size
          )
        end
      end
    end
  end
end
