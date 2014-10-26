require 'rails_helper'

describe User::AnswersController do
  render_views
  include_context 'user signed in'

  describe '#index' do
    let(:chart) { GoogleVisualr::Interactive::AreaChart.new(GoogleVisualr::DataTable.new) }
    let(:call_request) { get :index }
    before { allow(Chart).to receive(:for_current_user).and_return(chart) }

    it 'should show chart' do
      expect(Chart).to receive(:for_current_user).with(user)
      call_request
    end

    context 'after call_request' do
      before { call_request }

      it { should render_template 'index' }
    end
  end

  describe '#update' do
    let(:answer) { create(:answer, user: user) }
    let(:call_request) { xhr :put, :update, params }

    context 'correct params' do
      let(:params) { {id: answer.id, answer: {result: '3'}} }
      before { allow_any_instance_of(Answer).to receive(:update_by_user).and_return(true) }

      it 'should update answer' do
        expect_any_instance_of(Answer).to receive(:update_by_user).with(result: '3').and_call_original
        call_request
      end
    end

    context 'wrong id' do
      let(:params) { {id: '0', answer: {result: '3'}} }

      it 'should NOT update answer' do
        expect_any_instance_of(Answer).not_to receive(:update_by_user)
        call_request
      end
    end
  end
end
