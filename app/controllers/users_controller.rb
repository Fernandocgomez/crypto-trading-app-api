class UsersController < ApplicationController

    skip_before_action :check_authentication, only: [:create]

    # Tested and working
    def show 
        user = User.find_by(id: params[:id])
        render json: user.to_json(:only => [:username, :email, :first_name, :last_name])
    end
    # Tested and working
    def create 
        user = User.new(user_params)
        if user.valid? 
            user.save
            portafolio = Portafolio.create(name: "#{user.username}'s Portafolio", user_id: user.id, balance: 0.00)
            balance_tracking = BalanceTracking.create(total: 0.00, portafolio_id: portafolio.id, date_time: Time.now.in_time_zone("Central Time (US & Canada)").strftime('%a, %d %b %Y %H:%M:%S'))
            render json: {user: UserSerializer.new(user), portafolio: PortafolioSerializer.new(portafolio)}, status: :created
        else
            render json: {error: user.errors.full_messages}, status: :not_acceptable
        end
    end

    # Tested and working
    def update
        user = User.find_by(id: params[:id])
        user.assign_attributes(update_params)
        if user.valid? 
            user.update(update_params)
            render json: user.to_json(:only => [:username, :email, :first_name, :last_name])
        else 
            render json: {error: user.errors.full_messages}, status: :not_acceptable
        end
    end

    private 

    def user_params
        params.permit(:username, :password, :password_confirmation, :email, :email_confirmation, :first_name, :last_name)
    end

    def update_params
        params.permit(:username, :password, :email, :first_name, :last_name)
    end

end
