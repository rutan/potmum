# frozen_string_literal: true
class LobbiesController < ApplicationController
  before_action :set_page

  # GET /
  # 新着順のエイリアス
  def root
    newest
  end

  # GET /newest
  # 新着順
  def newest
    @mode = :newest
    @articles = Article.public_items.includes(:user, :tags).page(@page)
    render :root
  end

  # GET /popular
  # 人気順
  def popular
    @mode = :popular
    @articles = Article.popular.includes(:user, :tags).page(@page)
    render :root
  end

  # GET /comments
  # 新着コメント一覧
  def comments
    @mode = :comments
    @comments = Comment.recent(current_user).includes(:user, :article).page(@page)
    render :root
  end

  # GET /search
  # 検索結果
  def search
    @search_word = params[:q].to_s.strip[0..64]
    @q = Article
         .public_or_mine(current_user)
         .ransack(
           groupings: @search_word.split(/\p{blank}/).map do |word|
             {title_or_newest_revision_body_or_tags_content_cont: word}
           end,
           m: 'and'
         )
    @articles = @q.result(distinct: true).includes(:user, :newest_revision, :tags).page(@page)
  end

  # GET /redirect?url=:url
  # リダイレクタ
  def redirector
    @url = params[:url].to_s.strip[0, 255]
    raise Errors::BadRequest unless @url =~ /\Ahttps?:\/\/.+/
  end

  # GET /browserconfig.xml
  def browserconfig
    raise Errors::NotFound unless params[:format] == 'xml'
    render layout: nil
  end
end
