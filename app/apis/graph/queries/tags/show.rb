# frozen_string_literal: true
module Graph
  module Queries
    module Tags
      Show = GraphQL::Field.define do |field|
        field.type -> { Types::Tag }
        field.description 'Get a tag'

        field.argument :id, types.ID
        field.argument :name, types.String

        field.resolve Graph::Handler.new -> (_obj, args, context) do
          case
          when args[:id]
            ::Tag.find_by!(key: args[:id].match(/\ATag::(.+)\z/).try(:[], 1))
          when args[:name]
            ::Tag.find_by!(content: Tag.normalize(args[:name]))
          end.tap do |tag|
            Pundit.authorize(context[:access_token], tag, :show?) if tag
          end
        end
      end
    end
  end
end
