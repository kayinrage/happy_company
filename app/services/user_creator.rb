class UserCreator
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def perform!
    if user.valid?
      user.save
      create_first_answer
      user
    else
      false
    end
  end

  private

  def create_first_answer
    user.answers.create(date: Date.today)
  end
end
