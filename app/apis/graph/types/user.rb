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

      field :articles, types[Types::Article] do
        argument :size, types.Int, 'get size', default_value: 10
        argument :page, types.Int, 'page', default_value: 1

        resolve Graph::Handler.new -> (obj, args, context) do
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max
          obj.articles
             .public_or_mine(context[:access_token].try(:user))
             .page(page)
             .per(size)
        end
      end

      field :stockArticles, types[Types::Article] do
        argument :size, types.Int, 'get size', default_value: 10
        argument :page, types.Int, 'page', default_value: 1

        resolve Graph::Handler.new -> (obj, args, context) do
          Pundit.authorize(context[:access_token], obj, :show_stocks?)
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max
          context[:access_token].user
                                .stock_articles
                                .page(page)
                                .per(size)
        end
      end

      field :likeArticles, types[Types::Article] do
        argument :size, types.Int, 'get size', default_value: 10
        argument :page, types.Int, 'page', default_value: 1

        resolve Graph::Handler.new -> (obj, args, context) do
          Pundit.authorize(context[:access_token], obj, :show_likes?)
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max
          context[:access_token].user
                                .like_articles
                                .page(page)
                                .per(size)
        end
      end

      field :drafts, types[Types::Revision] do
        resolve Graph::Handler.new -> (obj, _args, context) do
          Pundit.authorize(context[:access_token], obj, :show_drafts?)
          obj.revisions.draft
        end
      end

      field :comments, types[Types::Comment] do
        argument :size, types.Int, 'get size', default_value: 10
        argument :page, types.Int, 'page', default_value: 1

        resolve Graph::Handler.new -> (obj, args, context) do
          size = [[args[:size], 25].min, 1].max
          page = [[args[:page], 100].min, 1].max
          obj.comments
             .recent(context[:access_token].try(:user))
             .includes(:article)
             .page(page)
             .per(size)
        end
      end
    end
  end
end
