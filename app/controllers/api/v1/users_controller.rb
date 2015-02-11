class Api::V1::UsersController < Api::ApiController
  # respond_to :json

  # before_action :authenticate

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find_by(id: params[:id])
    render json: @user || {}, status: (@user.nil? ? :not_found : :ok)
  end

  def update
    user = User.find_by(id: params[:id])

    if user && user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      # location returns url of newly created resource
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  # authenticate update action
  # before_filter set_user for methods that need it

  private

    def user_params
      params.require(:user).permit(:email, :username, :password)
    end

end
