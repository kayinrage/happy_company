class User::HomeController < User::UserController

  def index
    answer = current_user.answers.find_by_date(Date.today)
    @answer = answer ? answer : current_user.answers.create(date: Date.today)
  end

end