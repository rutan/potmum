# frozen_string_literal: true

class SearchArticleService
  def call(query:, access_token: nil, page: 0, size: 20)
    page = [[page, 100].min, 1].max
    size = [[size, 25].min, 1].max

    result = search_by_ransack(access_token.try(:user), query, page, size)

    SearchResult.new(
      query: query,
      size: size,
      page: page,
      articles: result,
      total_count: result.total_count
    )
  end

  private

  def search_by_ransack(access_user, query, page, size)
    ::Article
      .public_or_mine(access_user)
      .ransack(
        groupings: query.split(/\p{blank}/).map do |word|
          { title_or_newest_revision_body_or_tags_content_cont: word }
        end,
        m: 'and'
      )
      .result(distinct: true)
      .includes(:user, :newest_revision, :tags)
      .page(page)
      .per(size)
  end
end
