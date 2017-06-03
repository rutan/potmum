# frozen_string_literal: true
module Graph
  module Mutations
    module Comments
      AddCommentType = GraphQL::InputObjectType.define do
        name 'AddCommentType'

        argument :articleId, !types.String
        argument :body, !types.String
      end

      AddComment = GraphQL::Field.define do |field|
        field.type Graph::Types::Comment
        field.description 'Create a post'

        field.argument :input, AddCommentType

        field.resolve Graph::Handler.new -> (_obj, args, context) do
          params = args[:input]

          AddCommentService.new.call(
            access_token: context[:access_token],
            article_id: params[:articleId],
            body: params[:body]
          ).decorate
        end
      end
    end
  end
end
