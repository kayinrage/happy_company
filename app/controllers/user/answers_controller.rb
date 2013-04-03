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
      flash[:message] = "You answer has been changed."
      redirect_to user_root_path
    else
      flash[:error] = "Something went wrong..."
      render "user/home/index"
    end
  end

  def index
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Day')
    data_table.new_column('number', 'Happiness', (0..3))
    data_table.add_rows(current_user.answers.limit(30).order("date desc").reverse.map { |a| [a.date.to_s, a.result] })
    option = {width: 800, height: 600, title: 'Your last 30 days', vAxis: { viewWindow: {min: 0, max: 3}, :format => "#", gridlines: {count: 4}}}
    @chart = GoogleVisualr::Interactive::AreaChart.new(data_table, option)
  end

end