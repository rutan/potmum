class StocksController < ApplicationController
  before_action :set_article!
  before_action :set_stock

  # GET /items/:id/stock
  # ストック状態の取得
  def show
    render_json({article_id: @article.id, stocked: !@stock.new_record?})
  end

  # PUT /@user-name/items/:id/stock
  # ストック状態の変更
  def update
    stocked = (params[:stocked].to_i != 0)
    puts stocked.inspect
    if stocked
      @stock.save!
    else
      @stock.destroy
    end
    @article.update_count
    render_json({article_id: @article.id, stocked: stocked})
  end

  private

  def set_article!
    @article = Article.find(params[:article_id])
    @article_d = @article.decorate
  end

  def set_stock
    @stock = Stock.find_or_initialize_by(user_id: current_user.id, article_id: @article.id)
  end
end
