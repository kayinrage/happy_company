class Api::AnswersController < ApplicationController
  def show
    result = Answer.update_through_api(params)
    flash[result[:status] == 'fail' ? :error : :notice] = result[:message]
    redirect_to current_user ? user_root_path : root_path
  end
end
