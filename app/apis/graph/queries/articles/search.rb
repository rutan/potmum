# frozen_string_literal: true

module Graph
  module Queries
    module Articles
      Search = GraphQL::Field.define do |field|
        field.type -> { Connections::SearchResult }
        field.description 'Search articles'

        field.argument :query, !types.String, 'search query'
        field.argument :sort, types.String, default_value: 'published_at'
        field.argument :order, types.String, default_value: 'desc'

        SORT_TYPES = %w[publishedAt viewCount stockCount commentCount].freeze
        ORDER_TYPES = %w[asc desc].freeze

        field.resolve Graph::Handler.new ->(_obj, args, context) do
          query = args[:query]
          sort = args[:sort]
          order = args[:order]
          raise GraphQL::ExecutionError, 'Invalid sort format' unless SORT_TYPES.include?(sort)
          raise GraphQL::ExecutionError, 'Invalid order format' unless ORDER_TYPES.include?(order)

          ::Article
            .public_or_mine(context[:access_token].try(:user))
            .except(:order).order(sort.underscore => order)
            .ransack(
              groupings: (query.split(/\p{blank}/).map do |word|
                { title_or_newest_revision_body_or_tags_content_cont: word }
              end),
              m: 'and'
            )
            .result(distinct: true)
            .includes(:user, :newest_revision, :tags)
        end
      end
    end
  end
end
