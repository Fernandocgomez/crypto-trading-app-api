class HomeController < ApplicationController

  skip_before_action :check_authentication, only: [:index]

  # This method just display "This is my api" on JSON on the Home page
  def index
    render json: {message: "This is my api"}
  end

end
