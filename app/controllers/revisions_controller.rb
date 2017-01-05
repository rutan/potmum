# frozen_string_literal: true
class RevisionsController < ApplicationController
  before_action :set_user!
  before_action :set_article!
  before_action :set_revision!, only: [:show, :preview]

  # GET /@:name/items/xxxx/revisions
  def index
  end

  # GET /@:name/items/xxxx/revisions/xxxx
  def show
    @mode = :show
    Diffy::Diff.default_format = :html
    @diff = {
      title: Diffy::Diff.new(@revision.prev_revision.try(:title).to_s, @revision.title),
      tags: Diffy::Diff.new(@revision.prev_revision.try(:tags_text).to_s, @revision.tags_text),
      body: Diffy::Diff.new(@revision.prev_revision.try(:body).to_s, @revision.body)
    }
  end

  def preview
    @mode = :preview
    render :show
  end

  private

  def set_user!
    @user = User.find_by!(name: params[:name])
  end

  def set_article!
    @article = @user.articles.find(params[:article_id])
    @article_d = @article.decorate
  end

  def set_revision!
    @revision = Revision.find(params[:id])
    raise '404' unless @revision.article_id == @article.id
  end
end
