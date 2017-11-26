# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.find_by_uuid_value(uuid_value)
    find_by(id: uuid_value)
  end
end
