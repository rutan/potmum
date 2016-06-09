module PotmumAPIs
  module V1
    class Root < Grape::API
      content_type :json, 'application/json'
      formatter :json, Grape::Formatter::Rabl
      error_formatter :json, PotmumAPIs::V1::Formatters::ErrorFormatter
      version 'v1', using: :path

      before do
        @access_token = AccessToken.find_by(token: params[:access_token])
        error!('invalid token', 401) unless @access_token
      end

      mount ArticleAPI
    end
  end
end
