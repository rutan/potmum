# frozen_string_literal: true
module Graph
  module Types
    User = GraphQL::ObjectType.define do
      name 'User'
      description 'A user'

      field :id, types.Int
      field :name, types.String
      field :url, types.String
      field :avatarURL, types.String, property: :avatar_url
      field :stockCount, types.Int, property: :stock_count
      field :comments, types[Types::Comment] do
        argument :size, types.Int, 'get size', default_value: 10
        argument :page, types.Int, 'page', default_value: 1

        resolve -> (obj, args, context) do
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max
          obj.comments.recent(context[:pundit_user]).includes(:article).page(page).per(size)
        end
      end
    end
  end
end
