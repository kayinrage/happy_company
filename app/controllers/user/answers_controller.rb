class User::AnswersController < User::UserController
  def index
    @chart = Chart.for_current_user(current_user)
  end

  def update
    respond_to do |format|
      format.js { @result = Answer.update_by_user(current_user, answer_params) }
    end
  end

  private

  def answer_params
    # TODO narrow it down! changing update_by_user required
    params.permit!
  end
end
