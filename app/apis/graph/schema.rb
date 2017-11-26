# frozen_string_literal: true

module Graph
  Schema = GraphQL::Schema.define do
    query Graph::Queries::RootQuery
    mutation Graph::Mutations::RootMutation
    max_depth 7
    default_max_page_size 50

    resolve_type Graph::Handler.new ->(obj, _ctx) {
      case obj
      when ::Article
        Types::Article
      when ::User
        Types::User
      when ::Comment
        Types::Comment
      when ::Revision
        Types::Revision
      when ::Tag
        Types::Tag
      end
    }

    OBJECT_CLASSES = [Article, User, Comment, Revision, Tag].freeze

    object_from_id Graph::Handler.new ->(id, context) {
      class_name, item_id = id.split('::', 2)
      return unless OBJECT_CLASSES.map(&:name).include?(class_name)
      class_name.constantize.find_by_uuid_value(item_id).tap do |record|
        Pundit.authorize(context[:access_token], record, :show?) if record
      end
    }
  end

  Schema.middleware << Graph::Middlewares::Decorator.new
end
