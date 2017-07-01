# frozen_string_literal: true
module Graph
  module Connections
    SearchResult = ::Graph::Types::Article.define_connection do
      name 'SearchResultConnection'

      field :totalCount do
        type types.Int
        resolve ->(obj, _args, _ctx) { obj.nodes.count }
      end
    end
  end
end
