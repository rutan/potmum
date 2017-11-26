# frozen_string_literal: true

module Graph
  module Mutations
    module Stocks
      AddStock = GraphQL::Relay::Mutation.define do
        name 'AddStockMutation'
        description 'Create a stock'

        input_field :subjectId, !types.ID

        return_field :article, Graph::Types::Article

        resolve Graph::Handler.new ->(_obj, inputs, context) do
          id = inputs[:subjectId].match(/\AArticle::(.+)\z/).try(:[], 1)

          stock = AddStockService.new.call(
            access_token: context[:access_token],
            article_id: id
          )
          { article: stock.article.decorate }
        end
      end
    end
  end
end
