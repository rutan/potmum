# frozen_string_literal: true
module Graph
  # referenced https://github.com/rmosolgo/graphql-ruby/issues/323
  class Handler
    def initialize(resolve_func)
      @resolve_func = resolve_func
    end

    def call(obj, args, context = nil)
      if context.nil?
        @resolve_func.call(obj, args)
      else
        @resolve_func.call(obj, args, context)
      end
    rescue GraphQL::ExecutionError => e
      raise e
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(', '))
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("not found '#{e.model}'")
    rescue Errors::Unauthorized, Errors::Forbidden, Pundit::NotAuthorizedError
      GraphQL::ExecutionError.new('you don\'t have access authority')
    rescue StandardError => e
      Rails.logger.error "#{e.inspect}\t#{e.backtrace}"
      GraphQL::ExecutionError.new('server error')
    end
  end
end
