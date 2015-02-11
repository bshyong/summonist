class Api::V1::UsersController < Api::ApiController
  # respond_to :json

  # before_action :authenticate

  def index
    @users = User.all
    render json: @users
  end
end
