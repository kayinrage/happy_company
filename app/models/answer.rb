class Answer < ActiveRecord::Base
  RESULT_VERY_HAPPY = 3.freeze
  RESULT_HAPPY = 2.freeze
  RESULT_SAD = 1.freeze
  RESULT_VERY_SAD = 0.freeze
  RESULTS = [RESULT_VERY_HAPPY, RESULT_HAPPY, RESULT_SAD, RESULT_VERY_SAD]

  attr_accessible :result, as: :user
  attr_accessible :date, :result

  validates :user_id, :date, :secret, :result, presence: true
  validates :date, uniqueness: {scope: :user_id}
  validates :result, inclusion: {in: RESULTS}

  before_validation :generate_secret
  before_validation :set_result

  belongs_to :user

  private

  def generate_secret
    self.secret = Utils.generate_secret if self.secret.blank?
  end

  def set_result
    self.result = user.answers.last.result if self.result.blank?
  end

  def send_message_to_user
    #TODO
    puts "send message to #{user.secret}"
  end

  public

  def self.update_by_user(current_user, params)
    answer = current_user.answers.find_by_id(params[:id])
    if answer and !answer.outdated?
      answer.update_attributes(params[:answer])
      answer.answered = true
      answer.save ? answer.result : false
    else
      false
    end
  end

  def self.update_through_api(params)
    answer = where(id: params[:id], secret: params[:secret]).first
    if answer
      return Utils.api_response('fail', 'You cannot answer outdated question!') if answer.outdated?
      return Utils.api_response('fail', 'You cannot change your answer through link! If you want to change your answer then please use web application.') if answer.answered?
      return Utils.api_response('fail', 'Result should be within range (0..3)') if !RESULTS.map { |i| i.to_s }.include?(params[:result])
      answer.result = params[:result]
      answer.answered = true
      if answer.save
        Utils.api_response('success', 'Answer has been successfully saved!')
      else
        Utils.api_response('fail', 'Answer has not been saved!')
      end
    else
      Utils.api_response('fail', 'Secret is incorrect!')
    end
  end

  def self.result_dictionary
    {RESULT_VERY_HAPPY => "Yes, I'm very happy about this day :D",
     RESULT_HAPPY => 'Yes, this day was nice :)',
     RESULT_SAD => 'No, it was an average day for me :/',
     RESULT_VERY_SAD => 'No, this day was a big disappointment :('}
  end

  def self.send_notifications
    #TODO settings - delivery_time
  end

  def outdated?
    date != Date.today
  end

  def selected?(int)
    answered? and result == int
  end

  def api_link(int)
    "http://" + Utils.mailer_host + "/api/answers/#{id}?secret=#{secret}&result=#{int}"
  end
end
