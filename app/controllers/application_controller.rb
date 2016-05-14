class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_session
  before_action :current_user

  before_action :private_mode! if GlobalSetting.private_mode?

  private

  def check_session
    session.clear if session[:last_update].to_i < 30.day.ago.to_i
    session[:last_update] = Time.zone.now.to_i
  end

  def current_user
    return nil unless session[:user_id]
    @current_user ||= User.find_by(id: session[:user_id].to_i)
  end

  def render_json(target, status: 200, message: '')
    render(json: {
             meta: {
               status: status,
               message: message
             },
             data: (target.is_a?(Array) ? target.map { |n| n.try(:decorate) || n } : target.try(:decorate) || target)
           }, status: status)
  end

  def require_login!
    raise Errors::Unauthorized unless current_user
  end

  alias private_mode! require_login!

  def set_page
    @page = [params[:page].to_i, 1].max
  end

  rescue_from Exception, with: :render_500 unless Rails.env.development?
  rescue_from Errors::BadRequest, with: :render_400
  rescue_from Errors::Forbidden, with: :render_403
  rescue_from Errors::Unauthorized, with: :render_401
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404 unless Rails.env.development?
  rescue_from Errors::NotFound, with: :render_404

  def render_error(status, message = '')
    @status = status
    @message = message
    respond_to do |format|
      format.html { render '/errors/common', status: @status }
      format.json { render_json({}, status: @status, message: @message) }
    end
  end

  def render_400
    render_error(400, 'Bad Request')
  end

  def render_401
    render_error(401, 'ログインしてください')
  end

  def render_403
    render_error(403, 'Forbidden')
  end

  def render_404
    render_error(404, 'Not Found')
  end

  def render_500
    render_error(500, 'Internal Server Error')
  end
end
