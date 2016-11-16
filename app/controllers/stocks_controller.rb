class StocksController < ApplicationController
  before_action :set_article!
  before_action :set_stock

  # GET /items/:id/stock
  # ストック状態の取得
  def show
    render_json(article_id: @article.id, stocked: !@stock.new_record?)
  end

  # POST /@:name/items/:id/stock
  def create
    stock = Stock.find_or_initialize_by(user_id: current_user.id, article_id: @article.id)
    if stock.save
      @article.update_stock_count
      render_json(article_id: @article.id, stocked: true)
    else
      render_json({article_id: @article.id}, status: 400)
    end
  end

  # DELETE /@:name/items/:id/stock
  def destroy
    stock = Stock.find_or_initialize_by(user_id: current_user.id, article_id: @article.id)
    stock.destroy
    @article.update_stock_count
    head :no_content
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
