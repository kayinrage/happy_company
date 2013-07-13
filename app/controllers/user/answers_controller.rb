class User::AnswersController < User::UserController

  def update
    respond_to do |format|
      format.js { @result = Answer.update_by_user(current_user, params) }
    end
  end

  def index
    @chart = Chart.for_current_user(current_user)
  end

end