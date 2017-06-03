# frozen_string_literal: true
module Graph
  module Types
    RootQuery = GraphQL::ObjectType.define do
      name 'RootQuery'
      description 'The query root'

      field :article do
        type -> { Types::Article }
        description 'Get an article'

        argument :id, types.String

        resolve -> (_object, args, context) do
          ::Article.find(args[:id]).tap do |article|
            Pundit.authorize(context[:access_token], article, :show?)
          end.decorate
        end
      end

      field :articles do
        type -> { types[Types::Article] }
        description 'Get articles'

        argument :size, types.Int, 'get size', default_value: 10
        argument :page, types.Int, 'page', default_value: 1

        resolve -> (_object, args, _context) do
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max
          ::Article.public_items.page(page).per(size).decorate
        end
      end

      field :user do
        type -> { Types::User }
        description 'Get a user'

        argument :id, types.Int

        resolve -> (_object, args, context) do
          ::User.find(args[:id]).tap do |user|
            Pundit.authorize(context[:access_token], user, :show?)
          end.decorate
        end
      end
    end
  end
end
