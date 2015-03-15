class Api::V1::SessionsController < Api::ApiController

  def create
    user = User.find_by_username(session_params[:username])

    if user && user.authenticate(session_params[:password])
      user.set_auth_token!
      user.update last_sign_in_at: Time.now, last_sign_in_ip: request.remote_ip

      render json: {user: UserSerializer.new(user, root: false), auth_token: user.auth_token}, status: 200, location: [:api, user]
    else
      render json: {errors: "Invalid login"}, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: request.headers['Authorization'])

    if user && user.update_attribute(:auth_token, nil)
      render json: {}, status: 204
    else
      render json: {}, status: 401
    end
  end

  private

    def session_params
      params.require(:session).permit(:username, :password)
    end

end
