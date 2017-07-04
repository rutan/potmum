# frozen_string_literal: true
module Graph
  module Mutations
    module Comments
      AddComment = GraphQL::Relay::Mutation.define do
        name 'AddCommentMutation'
        description 'Create a post'

        input_field :subjectId, !types.ID
        input_field :body, !types.String

        return_field :comment, Graph::Types::Comment

        resolve Graph::Handler.new -> (_obj, inputs, context) do
          id = inputs[:subjectId].match(/\AArticle::(.+)\z/).try(:[], 1)

          comment = AddCommentService.new.call(
            access_token: context[:access_token],
            article_id: id,
            body: inputs[:body]
          ).decorate
          { comment: comment }
        end
      end
    end
  end
end
