# frozen_string_literal: true

module Users
  class AuthenticationsController < ApplicationController
    before_action :require_login!
    before_action :require_auth!, only: [:new, :create]
    before_action :set_target_user, only: [:new, :create]
    before_action :set_authentication, only: [:destroy]

    def index
    end

    def new
      @auth_name = Authentication::SERVICE_NAMES[session[:auth]['provider']]
    end

    def create
      ActiveRecord::Base.transaction do
        if @target_user
          builder = TakeoverBuilder.new(current_user)
          builder.build(@target_user)
        end
        current_user.link_to_auth!(session[:auth])
      end
      session[:auth] = nil
      flash[:success] = 'ログイン情報を追加しました'
      redirect_to users_authentications_path
    end

    def destroy
      if current_user.authentications.size > 1
        @authentication.destroy!
        flash[:success] = 'ログイン情報を削除しました'
      else
        flash[:danger] = 'ログイン情報を削除できません'
      end
      redirect_to users_authentications_path
    end

    private

    def require_auth!
      session[:auth] || raise(Errors::Forbidden)
    end

    def set_target_user
      @target_user = User.find_by(id: session[:auth]['user_id']) if session[:auth]['user_id']
    end

    def set_authentication
      @authentication = current_user.authentications.find(params[:id])
    end
  end
end
