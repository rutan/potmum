# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :require_login!, only: [:edit, :update]
  before_action :set_tag, only: [:show, :popular, :edit, :update]
  before_action :set_page, only: [:show, :popular]

  # GET /tags
  # タグ一覧
  def index
    @tags = Tag.popular
  end

  # GET /tags/:content
  # タグ検索結果（新着順）
  def show
    @mode = :newest
    @articles = @tag.articles.public_or_mine(current_user).includes(:user, :tags).page(@page)
  end

  # GET /tags/:content/popular
  # タグ検索結果（人気順）
  def popular
    @mode = :popular
    @articles = @tag.articles.popular.includes(:user, :tags).page(@page)
    render :show
  end

  # GET /tags/:content/edit
  # タグ情報編集
  def edit
    @tag_for_input = Tag.find(@tag.id)
  end

  # PUT /tags/:content
  # タグ情報更新
  def update
    @tag_for_input = Tag.find(@tag.id)
    if @tag_for_input.update(tag_params)
      redirect_to tag_path(@tag_for_input)
    else
      render :edit
    end
  end

  private

  def set_tag
    @tag = Tag.find_by!(content: params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :is_menu)
  end
end
