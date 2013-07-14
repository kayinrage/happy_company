class NotificationMailer < ActionMailer::Base
  default from: 'no-replay@happycompany.com'

  def everyday_question(user, answer)
    @user, @answer = user, answer
    mail(to: @user.email, subject: 'Are you happy today?')
  end


end