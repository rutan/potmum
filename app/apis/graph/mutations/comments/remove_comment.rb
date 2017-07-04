# frozen_string_literal: true
module Graph
  module Mutations
    module Comments
      RemoveComment = GraphQL::Relay::Mutation.define do
        name 'RemoveCommentMutation'
        description 'Remove a comment'

        input_field :commentId, !types.ID

        return_field :article, Graph::Types::Article

        resolve Graph::Handler.new -> (_obj, inputs, context) do
          key = inputs[:commentId].match(/\AComment::(.+)\z/).try(:[], 1)

          article = RemoveCommentService.new.call(
            access_token: context[:access_token],
            comment_key: key
          ).decorate
          { article: article }
        end
      end
    end
  end
end
