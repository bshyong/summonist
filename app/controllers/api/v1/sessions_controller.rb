class Api::V1::SessionsController < Api::ApiController
  def create
    user = User.find_by_email(params[:username])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(params[:password])
      # return auth token
    else
      # render 403?
    end
  end

  def destroy
    # set auth token to nil
  end
end
