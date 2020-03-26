class ApplicationController < ActionController::API

    # before_action :check_authentication

    def encode_token(playload)
        JWT.encode(playload, "tradeing", "HS256")
    end

    def auth_header
        # { 'Authorization': 'Bearer <token>' }
        request.headers['Authorization']
    end

    def current_user
        if decoded_token
          user_id = decoded_token["user_id"]
          User.find(user_id)
        end
    end

    def decoded_token
        # token => "eyJhbGciOiJIUzI1NiJ9.eyJiZWVmIjoic3RlYWsifQ._IBTHTLGX35ZJWTCcY30tLmwU9arwdpNVxtVU0NpAuI"
       if auth_header
        token = auth_header.split(' ')[1]
        puts token
           # byebug
        begin
           # byebug
          JWT.decode(token,"tradeing")[0] #pass the same key
           # JWT.decode => [{ "user_id"=>"18" }, { "alg"=>"HS256" }]
           # [0] gives us the payload { "user_id"=>"18" }
        rescue JWT::DecodeError
           nil
        end
       end
    end

    def check_authentication
        render json: { error: 'Please log in' }, status: 401 if !logged_in?
    end
    
    def logged_in?
        !!current_user
    end



end
