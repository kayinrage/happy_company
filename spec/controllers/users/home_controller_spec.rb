require 'rails_helper'

describe User::HomeController do
  render_views
  include_context 'user signed in'

  describe '#index' do
    let(:call_request) { get :index }

    it 'should create answer for current_user if answer does NOT exist for current day' do
      expect { call_request }.to change { user.answers.count }.by 1
    end

    context 'answer exists for current day' do
      before { user.answers.create(date: Date.today) }

      it 'should NOT create answer' do
        expect { call_request }.not_to change { user.answers.count }
      end
    end

    context 'after call_request' do
      before { call_request }

      it { should render_template 'index' }
    end
  end
end
