require 'rails_helper'

describe Api::AnswersController do
  render_views
  let!(:answer) { create(:answer, secret: 'secret', result: 1) }

  describe '#show' do
    let(:call_request) { get :show, params }

    context 'with correct params' do
      let(:params) { {id: answer.id, secret: 'secret', result: '3'} }
      before { allow_any_instance_of(ApiAnswerUpdater).to receive(:perform!).and_return(status: 'success', message: 'success') }

      it 'should update answer' do
        expect(ApiAnswerUpdater).to receive(:new).with(answer, '3').and_call_original
        expect_any_instance_of(ApiAnswerUpdater).to receive(:perform!).and_call_original
        call_request
      end

      context 'after call request' do
        before { call_request }

        it 'should display correct flash message' do
          expect(flash[:notice]).to eq 'success'
        end

        it 'should redirect to root_path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'when user logged in' do
        include_context 'user signed in'

        it 'should redirect to user_root_path' do
          call_request
          expect(response).to redirect_to user_root_path
        end
      end
    end

    context 'with wrong params' do
      context 'because of incorrect id' do
        let(:params) { {id: answer.id, secret: nil, result: '3'} }

        include_examples 'api_answers_controller with incorrect params'
      end

      context 'because of incorrect secret' do
        let(:params) { {id: 0, secret: 'secret', result: '3'} }

        include_examples 'api_answers_controller with incorrect params'
      end
    end
  end
end
