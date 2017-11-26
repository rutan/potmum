# frozen_string_literal: true

class AddStockService
  def call(access_token:, article_id:)
    article = ::Article.find(article_id)
    Pundit.authorize(access_token, article, :add_stock?)

    ::Stock.create!(
      article_id: article.id,
      user_id: access_token.user.id
    ).tap do
      article.update_stock_count
    end
  end
end
