class Answer < ActiveRecord::Base
  RESULT_VERY_HAPPY = 3.freeze
  RESULT_HAPPY = 2.freeze
  RESULT_SAD = 1.freeze
  RESULT_VERY_SAD = 0.freeze
  RESULTS = [RESULT_VERY_HAPPY, RESULT_HAPPY, RESULT_SAD, RESULT_VERY_SAD]

  belongs_to :user

  validates :user_id, :date, :secret, :result, presence: true
  validates :date, uniqueness: {scope: :user_id}
  validates :result, inclusion: {in: RESULTS}

  before_validation :generate_secret
  before_validation :set_result

  def self.result_dictionary
    {RESULT_VERY_HAPPY => "Yes, I'm very happy about this day :D",
     RESULT_HAPPY => 'Yes, this day was nice :)',
     RESULT_SAD => 'No, it was an average day for me :/',
     RESULT_VERY_SAD => 'No, this day was a big disappointment :('}
  end

  def self.send_notifications
    #TODO settings - delivery_time
  end

  def update_by_user(answer_params)
    unless outdated?
      update_attributes(answer_params)
      self.answered = true
      save ? result : false
    else
      false
    end
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

  private

  def generate_secret
    self.secret = Utils.generate_secret if self.secret.blank?
  end

  def set_result
    self.result = if result.present?
                    result
                  else
                    user.answers.last.result rescue 1
                  end
  end

  def send_message_to_user
    #TODO
    puts "send message to #{user.secret}"
  end
end
