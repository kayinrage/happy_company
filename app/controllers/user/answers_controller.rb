class User::AnswersController < User::UserController

  def create
    @answer = current_user.answers.build(params[:answer])
    @answer.date = Date.today
    if @answer.save
      flash[:message] = "Thank you for your answer."
      redirect_to user_root_path
    else
      flash[:error] = "Something went wrong..."
      render "user/home/index"
    end
  end

  def update
    @answer = current_user.answers.find(params[:id])
    @answer.update_attributes(params[:answer])
    @answer.date = Date.today
    if @answer.save
      flash[:message] = "Your answer has been changed."
      redirect_to user_root_path
    else
      flash[:error] = "Something went wrong..."
      render "user/home/index"
    end
  end

  def index
    @chart = Chart.for_current_user(current_user)
  end

end