class AuthController < ApplicationController

  # skip_before_action :check_authentication, only: [:create]

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      render json: {user: user, token: encode_token({user_id: user.id}), portafolio: user.portafolio}
    else 
      render json: {error: "Invalid username or password"}, status: :not_acceptable
    end
  end

end
