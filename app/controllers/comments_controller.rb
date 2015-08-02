class CommentsController < ApplicationController
  before_action :require_login!
  before_action :set_user_and_article!, only: [:create]
  before_action :set_comment!, only: [:destroy]

  # POST /@:name/items/:article_id/comments.json
  def create
    @comment = Comment.new(
        user: current_user,
        article: @article,
        body: params[:body]
    )
    if @comment.save
      @article.update_comment_count
      render_json @comment, status: 201
    else
      render_json({}, status: 400)
    end
  end

  # POST /comments/preview.json
  def preview
    @comment = Comment.new(
        user: current_user,
        body: params[:body]
    )
    if @comment.valid?
      render_json @comment
    else
      render_json({}, status: 400)
    end
  end

  # DELETE /comments/:id.json
  def destroy
    raise Errors::Forbidden unless current_user == @comment.user
    article = @comment.article
    @comment.destroy
    article.update_comment_count

    respond_to do |format|
      format.html { redirect_to article_path(article, name: article.user.name) }
      format.json { render_json({}, status: 200) }
    end
  end

  private

  def set_user_and_article!
    @user = User.find_by!(name: params[:name])
    @article = @user.articles.find(params[:article_id])
  end

  def set_comment!
    @comment = Comment.find(params[:id])
  end
end
