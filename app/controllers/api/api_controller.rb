class Api::ApiController < ApplicationController

  def current_user
    @current_user ||= User.where.not(auth_token: nil).find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless current_user.present?
  end

  def user_signed_in?
    current_user.present?
  end

  # private
  #
  # def authenticate
  #   authenticate_token || render_unauthorized
  # end
  #
  # def authenticate_token
  #   authenticate_or_request_with_http_token do |token, options|
  #     @current_user = User.find_by(auth_token: token)
  #   end
  #   # api_key = request.headers['X-Api-Key']
  #   # @user = User.where(api_key: api_key).first if api_key
  #   #
  #   # unless @user
  #   #   head status: :unauthorized
  #   #   return false
  #   # end
  # end
  #
  # def render_unauthorized
  #   self.headers['WWW-Authenticate'] = 'Token realm="Application"'
  #   render json: 'Bad credentials', status: 401
  # end
end
