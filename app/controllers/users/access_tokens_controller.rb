# frozen_string_literal: true

module Users
  class AccessTokensController < ::ApplicationController
    before_action :require_login!
    before_action :set_access_token!, only: [:destroy]

    # GET /settings/tokens
    def index
      @access_tokens = current_user.access_tokens
    end

    # POST /settings/tokens
    def create
      @access_token = AccessToken.new(access_tokens_params)
      @access_token.title = Time.zone.now if @access_token.title.empty?
      @access_token.token_type = :user_token
      @access_token.user_id = current_user.id
      if @access_token.save
        flash[:success] = '作成しました'
      else
        flash[:danger] = '作成できませんでした'
      end
      redirect_to users_access_tokens_path
    end

    # DELETE /settings/tokens/:id
    def destroy
      @access_token.destroy
      flash[:success] = '削除しました'
      redirect_to users_access_tokens_path
    end

    private

    def set_access_token!
      @access_token = AccessToken.find_by(id: params[:id], user_id: current_user.id)
    end

    def access_tokens_params
      params.permit(:title, :permit_type)
    end
  end
end
