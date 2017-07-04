# frozen_string_literal: true
class RemoveStockService
  def call(access_token:, article_id:)
    article = ::Article.find(article_id)
    Pundit.authorize(access_token, article, :add_stock?)

    stock = ::Stock.find_by!(
      article_id: article.id,
      user_id: access_token.user.id
    )
    stock.destroy!
    article.update_stock_count
    article
  end
end
