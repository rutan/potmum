# frozen_string_literal: true

module Graph
  module Queries
    module Users
      Show = GraphQL::Field.define do |field|
        field.type -> { Types::User }
        field.description 'Get a user'

        field.argument :id, types.ID
        field.argument :name, types.String

        field.resolve Graph::Handler.new ->(_obj, args, context) do
          user =
            case
            when args[:id]
              ::User.find(args[:id].match(/\AUser::(\d+)\z/).try(:[], 1))
            when args[:name]
              ::User.find_by!(name: args[:name])
            else
              context[:access_token].try(:user)
            end

          return unless user
          Pundit.authorize(context[:access_token], user, :show?)
          user
        end
      end
    end
  end
end
