require 'rails_helper'

describe Api::AnswersController do
  render_views

  describe '#show' do
    let(:call_request) { get :show, params }

    context 'with correct params' do
      let(:params) { {id: '1', secret: 'secret', result: '3'} }
      before { allow(Answer).to receive(:update_through_api).and_return(status: 'success', message: 'success') }

      it 'should update answer' do
        expect(Answer).to receive(:update_through_api).with(hash_including(params)).and_call_original
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
      let(:params) { {id: '1', secret: nil, result: '3'} }
      before { allow(Answer).to receive(:update_through_api).and_return(status: 'fail', message: 'fail') }

      it 'should update answer' do
        expect(Answer).to receive(:update_through_api).with(hash_including(params)).and_call_original
        call_request
      end

      context 'after call request' do
        before { call_request }

        it 'should display correct flash message' do
          expect(flash[:error]).to eq 'fail'
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
  end
end
