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
    let(:params) { {id: '1', result: '3'} }
    let(:call_request) { xhr :put, :update, params }
    before { allow(Answer).to receive(:update_by_user).and_return(true) }

    it 'should update answer' do
      expect(Answer).to receive(:update_by_user).with(user, hash_including(params)).and_call_original
      call_request
    end
  end
end
