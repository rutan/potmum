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
      field :contribute, types.Int, property: :stock_count

      connection :articles, -> { Connections::Article } do
        resolve Graph::Handler.new -> (obj, _args, context) do
          obj.articles.public_or_mine(context[:access_token].try(:user))
        end
      end

      connection :stockArticles, -> { Connections::Article } do
        resolve Graph::Handler.new -> (obj, _args, context) do
          Pundit.authorize(context[:access_token], obj, :show_stocks?)
          context[:access_token].user
                                .stock_articles
        end
      end

      connection :likeArticles, -> { Connections::Article } do
        resolve Graph::Handler.new -> (obj, _args, context) do
          Pundit.authorize(context[:access_token], obj, :show_likes?)
          context[:access_token].user
                                .like_articles
        end
      end

      connection :drafts, -> { Connections::Revision } do
        resolve Graph::Handler.new -> (obj, _args, context) do
          Pundit.authorize(context[:access_token], obj, :show_drafts?)
          obj.revisions.draft
        end
      end

      connection :comments, -> { Connections::Comment } do
        resolve Graph::Handler.new -> (obj, _args, context) do
          obj.comments
             .recent(context[:access_token].try(:user))
             .includes(:article)
        end
      end
    end
  end
end
