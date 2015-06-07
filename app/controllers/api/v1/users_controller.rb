class Api::V1::UsersController < Api::ApiController
  before_action :authenticate_with_token!, except: [:create]

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find_by(id: params[:id])
    render json: @user || {}, status: (@user.nil? ? :not_found : :ok)
  end

  def set_location
    user = current_user
    location = params[:location]
    if user.update! lat: location[:lat], lng: location[:lng]
      render json: user, status: 200, location: [:api, user]
    else
      render json: {errors: user.errors}, status: 422
    end
  end

  # {
  #     deltaLat = "0.0901031127257856";
  #     deltaLng = "0.1128458381110202";
  #     location =     {
  #         lat = "37.3376772";
  #         lng = "-122.03083657";
  #     };
  # }
  def nearby
    user = current_user
    location = params[:location]
    deltaLat = params[:deltaLat]
    deltaLng = params[:deltaLng]

    render json: user.nearby(location: location, deltaLat: deltaLat, deltaLng: deltaLng), root: false
  end

  def update
    user = current_user

    if user && user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: "Something went wrong" }, status: 422
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

  private

    def user_params
      params.require(:user).permit(:email, :username, :password)
    end

end
