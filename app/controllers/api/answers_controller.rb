class Api::AnswersController < ApplicationController
  def show
    result = Answer.update_through_api(answer_params)
    flash[result[:status] == 'fail' ? :error : :notice] = result[:message]
    redirect_to current_user ? user_root_path : root_path
  end

  private

  def answer_params
    # TODO narrow it down! changing update_by_user required
    params.permit!
  end
end
