# frozen_string_literal: true
module Graph
  module Types
    User = GraphQL::ObjectType.define do
      name 'User'
      description 'A user'

      implements GraphQL::Relay::Node.interface

      field :id, !types.ID, property: :uuid
      field :objectId, types.Int, property: :id
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
        argument :order, types.String, default_value: 'desc'
        order_types = %w(asc desc).freeze

        resolve Graph::Handler.new -> (obj, args, context) do
          order = args[:order]
          raise GraphQL::ExecutionError, 'Invalid order format' unless order_types.include?(order)

          obj.object.comments
             .recent(context[:access_token].try(:user))
             .except(:order).order(created_at: order)
             .includes(:article)
        end
      end
    end
  end
end
