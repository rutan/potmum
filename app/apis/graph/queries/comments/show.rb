# frozen_string_literal: true
module Graph
  module Queries
    module Comments
      Show = GraphQL::Field.define do |field|
        field.type -> { Types::Comment }
        field.description 'Get a comment'

        field.argument :id, types.ID

        field.resolve Graph::Handler.new -> (_obj, args, context) do
          ::Comment.find_by!(key: args[:id].match(/\AComment::(.+)\z/).try(:[], 1)).tap do |comment|
            Pundit.authorize(context[:access_token], comment, :show?) if comment
          end
        end
      end
    end
  end
end
