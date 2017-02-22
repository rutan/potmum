# frozen_string_literal: true
class SessionsController < ApplicationController
  skip_before_action :private_mode!, only: [:callback, :failure] if GlobalSetting.private_mode?

  def callback
    auth = request.env['omniauth.auth']
    redirect_to '/' unless auth

    user = User.find_by_auth(auth)

    if current_user
      # 既存アカウントとのヒモ付処理へ
      session[:auth] = {
        provider: auth[:provider],
        uid: auth[:uid],
        user_id: user.try(:id)
      }
      redirect_to new_users_authentication_path
    elsif user
      # ログインへ
      session[:user_id] = user.id
      redirect_to '/'
    else
      # アカウント新規登録画面へ
      session[:auth] = {
        provider: auth[:provider],
        uid: auth[:uid],
        info: { nickname: auth[:info][:nickname] }
      }
      redirect_to register_path
    end
  end

  def failure
    redirect_to '/'
  end

  def destroy
    session.clear
    redirect_to '/'
  end
end
