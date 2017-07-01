# frozen_string_literal: true
module DecorateSerializer
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      def serializable_hash(_options = nil)
        self.class.attr_lists.map do |n|
          [n, public_send(n)]
        end.to_h
      end

      def uuid
        "#{object.class.name}::#{object.id}"
      end
    end
  end

  module ClassMethods
    def define_attr(*args)
      @_attrs = args
    end

    def attr_lists
      @_attrs || []
    end
  end
end
