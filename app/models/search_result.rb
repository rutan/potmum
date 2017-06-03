# frozen_string_literal: true
class SearchResult
  include ActiveModel::Model

  attr_accessor :query, :page, :size, :total_count, :articles
end
