class UsersController < ApplicationController

    skip_before_action :check_authentication, only: [:create]

    def show # Tested and working
        user = User.find_by(id: params[:id])
        render json: user.to_json(:only => [:id, :username, :email])
    end

    def create #Tested and working
        user = User.new(user_params)
        if user.valid? 
            user.save
            portafolio = Portafolio.create(name: "#{user.username}'s Portafolio", user_id: user.id, balance: 0)
            render json: {user: UserSerializer.new(user), portafolio: PortafolioSerializer.new(portafolio)}, status: :created
        else
            render json: {error: user.errors.full_messages}, status: :not_acceptable
        end
    end

    private 

    def user_params
        params.permit(:username, :password, :password_confirmation, :email, :email_confirmation)
    end

end
