class HomeController < ApplicationController

  # skip_before_action :check_authentication, only: [:index]

  def index
    render json: {message: "This is my api"}
  end

end
