require 'spec_helper'

describe Devise::SessionsController do
  render_views
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#new' do
    before { get :new }

    it { should render_template 'new' }
  end

  describe '#create' do
    context 'when customer exist and correct attributes have been passed then login attempt' do
      let!(:subject) { create(:user, email: 'irek@happy.com') }

      let(:call_request) do
        subject.confirm!
        post :create, user: {email: subject.email, password: 'secret'}
      end

      before { call_request }

      it { should redirect_to user_root_path }
      it 'should display correct flash message' do
        expect(flash[:notice]).to eq I18n.t('devise.sessions.signed_in')
      end
    end

    context 'when invalid attributes has been passed then login attempt' do
      let(:call_request) { post :create, user: {email: 'error@gmail.com', password: 'secret'} }
      before { call_request }

      it { should render_template 'new' }
      it 'should display correct flash message' do
        expect(flash[:alert]).to eq I18n.t('devise.failure.invalid')
      end
    end
  end
end
