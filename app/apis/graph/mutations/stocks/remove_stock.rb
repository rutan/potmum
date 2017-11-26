# frozen_string_literal: true

module Graph
  module Mutations
    module Stocks
      RemoveStock = GraphQL::Relay::Mutation.define do
        name 'RemoveStockMutation'
        description 'Remove a stock'

        input_field :subjectId, !types.ID

        return_field :article, Graph::Types::Article

        resolve Graph::Handler.new ->(_obj, inputs, context) do
          id = inputs[:subjectId].match(/\AArticle::(.+)\z/).try(:[], 1)

          article = RemoveStockService.new.call(
            access_token: context[:access_token],
            article_id: id
          )
          { article: article.decorate }
        end
      end
    end
  end
end
