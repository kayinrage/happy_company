class ApiAnswerUpdater
  attr_reader :answer, :result, :response

  def initialize(answer, result)
    @answer = answer
    @result = result
    @response = {}
  end

  def perform!
    save_answer if answer_can_be_save?
    response
  end

  private

  def answer_can_be_save?
    answer_is_not_outdated? && answer_is_not_answered? && result_is_correct?
  end

  def answer_is_not_outdated?
    validation(answer.outdated?, 'You cannot answer outdated question!')
  end

  def answer_is_not_answered?
    validation(answer.answered?, 'You cannot change your answer through link! If you want to change your answer then please use web application.')
  end

  def result_is_correct?
    validation(!valid_result?, 'Result should be within range (0..3)')
  end

  def valid_result?
    Answer::RESULTS.map { |i| i.to_s }.include?(result)
  end

  def validation(expression, message)
    if expression
      @response = Utils.api_response('fail', message)
      false
    else
      true
    end
  end

  def save_answer
    answer.result = result
    answer.answered = true
    @response = if answer.save
                  Utils.api_response('success', 'Answer has been successfully saved!')
                else
                  Utils.api_response('fail', 'Answer has not been saved!')
                end
  end
end
