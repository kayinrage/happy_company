class Api::AnswersController < ApplicationController
  before_action :get_answer

  def show
    process_answer
    prepare_flash_message
    redirect_to current_user ? user_root_path : root_path
  end

  private

  def get_answer
    @answer = Answer.where(id: params[:id], secret: params[:secret]).first
  end

  def process_answer
    @result = if @answer
                ApiAnswerUpdater.new(@answer, result_params).perform!
              else
                Utils.api_response('fail', 'Secret is incorrect!')
              end
  end

  def prepare_flash_message
    flash[@result[:status] == 'fail' ? :error : :notice] = @result[:message]
  end

  def result_params
    params.require(:result)
  end
end
