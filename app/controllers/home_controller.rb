class HomeController < ApplicationController
  def index
    redirect_to user_root_path if current_user
  end
end
