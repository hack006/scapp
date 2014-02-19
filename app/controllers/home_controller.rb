class HomeController < ApplicationController

  def index
    authorize! :index, HomeController
    @users = User.all
  end
end
