# frozen_string_literal: true

module Graph
  module Middlewares
    class Decorator
      def call(_parent_type, _parent_object, _field_definition, _field_args, _query_context)
        result = yield
        result.try(:decorate) || result
      end
    end
  end
end
