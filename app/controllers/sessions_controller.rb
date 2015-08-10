class SessionsController < ApplicationController
  skip_before_action :require_login!, only: [:callback]

  def callback
    auth = request.env['omniauth.auth']
    redirect_to '/' unless auth

    if current_user
      # TODO: ログイン中は既存アカウントとのヒモ付処理へ
      redirect_to '/'
    else
      # 非ログイン: ログインの開始
      user = User.find_by_auth(auth)
      if user
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
  end

  def destroy
    session.clear
    redirect_to '/'
  end
end
