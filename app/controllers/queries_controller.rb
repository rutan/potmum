# frozen_string_literal: true
class QueriesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_csrf

  # POST /graphql.json
  def create
    query = params[:query].to_s
    render json: Graph::Schema.execute(
      query,
      context: {
        variables: param_variables,
        access_token: current_access_token,
        pundit: self
      }
    )
  end

  private

  def current_access_token
    if params[:token].present?
      AccessToken.find_by(token: params[:token])
    else
      super
    end
  end

  def private_mode!
    raise Errors::Unauthorized unless current_access_token.try(:user)
  end

  def check_csrf
    raise Errors::UnprocessableEntity unless request.headers['Host'] == safe_host
    x_from = request.headers['X-From']
    raise Errors::UnprocessableEntity if x_from.blank?
    origin = request.headers['Origin']
    raise Errors::UnprocessableEntity if origin && origin != 'null' && !x_from.start_with?("#{origin}/")
  end

  def safe_host
    GlobalSetting.root_url.match(/\/(?<host>[^\/]+)(?:\/|\z)/).try(:[], :host)
  end

  def param_variables
    variables = params[:variables]
    if variables.blank?
      {}
    elsif variables.is_a?(String)
      JSON.parse(variables, quirks_mode: true)
    else
      variables
    end
  end
end
