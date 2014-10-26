class User::AnswersController < User::UserController
  before_action :get_answer, only: :update

  def index
    @chart = Chart.for_current_user(current_user)
  end

  def update
    respond_to do |format|
      format.js { result }
    end
  end

  private

  def get_answer
    @answer = current_user.answers.find_by_id(params[:id])
  end

  def result
    @result = @answer ? @answer.update_by_user(answer_params) : false
  end

  def answer_params
    params.require(:answer).permit(:result)
  end
end
