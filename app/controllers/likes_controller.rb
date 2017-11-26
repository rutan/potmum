# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :set_user_and_article!, only: [:create, :destroy]

  # POST /@:name/items/:id/like
  def create
    like = Like.find_or_initialize_by(
      user_id: current_user.id,
      target_type: 'Article',
      target_id: @article.id
    )
    if like.save
      @article.update_like_count
      render_json(article_id: @article.id, liked: true)
    else
      render_json({ article_id: @article.id }, status: 400)
    end
  end

  # DELETE /@:name/items/:id/like
  def destroy
    like = Like.find_or_initialize_by(
      user_id: current_user.id,
      target_type: 'Article',
      target_id: @article.id
    )
    like.destroy
    @article.update_like_count
    head :no_content
  end

  private

  def set_user_and_article!
    @user = User.find_by!(name: params[:name])
    @article = @user.articles.find(params[:article_id])
  end
end
