class UsersController < ApplicationController
  before_action :check_register_mode!, only: [:new, :create]
  before_action :require_login!, only: [:edit, :update]
  before_action :set_user!, only: [:show, :drafts, :stock_articles, :comments]
  before_action :set_page, only: [:show, :drafts, :stock_articles, :comments]

  # GET /users/new
  # 新規登録画面
  def new
    @user = User.new(name: session['auth']['info']['nickname'])
  end

  # POST /users
  # 新規登録処理
  def create
    @user = User.new(user_params)
    ActiveRecord::Base.transaction do
      raise 'validation' unless @user.valid?
      @user.save!
      @user.link_to_auth!(session['auth'])
    end
    session['user_id'] = @user.id
    session['auth'] = nil
    redirect_to '/'
  rescue => e
    Rails.logger.error e.inspect
    render :new
  end

  # GET /@user-name
  def show
    @mode = :show
    @articles = @user.articles.public_or_mine(current_user).includes(:tags).page(@page)
  end

  # GET /@user-name/deafts
  def drafts
    @mode = :drafts
    @articles = @user.articles.drafts.includes(:tags).page(@page)
    render :show
  end

  # GET /@user-name/stocks
  def stock_articles
    @mode = :stock_articles
    @articles =
      if current_user == @user
        @user.stock_articles.includes(:user, :tags).page(@page)
      else
        @user.stock_articles.public_items.includes(:user, :tags).page(@page)
      end
    render :show
  end

  # GET /@user-name/comments
  def comments
    @mode = :comments
    @comments =
      if current_user == @user
        @user.comments.includes(:article).page(@page)
      else
        @user.comments.recent(current_user).includes(:article).page(@page)
      end
    render :show
  end

  # GET /setting
  def edit
    @user = current_user
  end

  # PUT /setting
  def update
    @user = current_user.clone
    flash[:success] = '更新しました' if @user.update(user_params)
    render 'edit'
  end

  private

  def set_user!
    @user = User.find_by!(name: params[:name])
  end

  def check_register_mode!
    raise Errors::BadRequest unless session['auth']
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
