# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def find_by_uuid_value(uuid_value)
      find_by(id: uuid_value)
    end

    def order_by_ids(ids = [])
      return nil if ids.blank?
      order_by = ['CASE']
      ids.each_with_index do |id, index|
        order_by.push "WHEN id='#{id}' THEN #{index}"
      end
      order_by.push 'END'
      order_by.join(' ')
    end
  end
end
