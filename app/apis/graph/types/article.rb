# frozen_string_literal: true

module Graph
  module Types
    Article = GraphQL::ObjectType.define do
      name 'Article'
      description 'A blog entry'

      implements GraphQL::Relay::Node.interface

      field :id, !types.ID, property: :uuid
      field :objectId, types.String, property: :id
      field :title, types.String
      field :publishType, types.String, property: :publish_type
      field :user, -> { Types::User }
      field :tags, -> { types[Types::Tag] }
      field :viewCount, types.Int, property: :view_count
      field :stockCount, types.Int, property: :stock_count

      field :body, types.String do
        resolve Graph::Handler.new ->(obj, _args, _context) do
          obj.newest_revision.body
        end
      end

      field :html, types.String do
        resolve Graph::Handler.new ->(obj, _args, _context) do
          obj.newest_revision.markdown_html
        end
      end

      field :publishedAt, types.Int do
        resolve Graph::Handler.new ->(obj, _args, _context) do
          obj.published_at ? obj.published_at.to_i : nil
        end
      end

      field :isStocked, types.Boolean do
        resolve Graph::Handler.new ->(obj, _args, context) do
          !!context[:access_token].try(:user).try(:stocked?, obj)
        end
      end

      field :isLiked, types.Boolean do
        resolve Graph::Handler.new ->(obj, _args, context) do
          !!context[:access_token].try(:user).try(:liked?, obj)
        end
      end

      connection :comments, -> { Connections::Comment } do
        argument :order, types.String, default_value: 'desc'
        order_types = %w[asc desc].freeze

        resolve Graph::Handler.new ->(obj, args, _context) do
          order = args[:order]
          raise GraphQL::ExecutionError, 'Invalid order format' unless order_types.include?(order)

          obj.object.comments.except(:order).order(created_at: order)
        end
      end

      connection :revisions, -> { Connections::Revision } do
        resolve Graph::Handler.new ->(obj, _args, _context) do
          obj.revisions.published
        end
      end
    end
  end
end
