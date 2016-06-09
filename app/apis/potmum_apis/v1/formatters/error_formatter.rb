module PotmumAPIs
  module V1
    module Formatters
      class ErrorFormatter
        def self.call(message, _backtrace, _options, env)
          env['api.tilt.rabl'] = 'v1/empty'
          env['api.tilt.rabl_locals'] = {
            message: message
          }
          unless env['api.endpoint'].instance_variable_get(:@error)
            env['api.endpoint'].instance_variable_set(:@error, message.to_s)
          end
          Grape::Rabl::Formatter.new(message, env).render
        end
      end
    end
  end
end
