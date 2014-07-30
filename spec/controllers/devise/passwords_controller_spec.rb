require 'spec_helper'

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

describe Devise::PasswordsController do
  render_views
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'customer exist' do
    let!(:subject) { create(:user, email: 'irek@happpy.com') }

    describe '#new' do
      let(:call_request) { get :new }
      before { call_request }

      it { should render_template 'new' }
    end

    describe '#edit' do
      let(:call_request) { get :edit, {reset_password_token: subject.reset_password_token} }
      before do
        subject.send_reset_password_instructions
        call_request
      end

      it { should render_template 'edit' }
    end

    describe '#create' do
      let(:call_request) { post :create, attrs }

      include_examples 'change password create valid attributes', 'downcase'
      include_examples 'change password create valid attributes', 'upcase'

      context 'when attributes are invalid' do
        let(:attrs) { {user: {email: 'error@error.com.pl'}} }

        it 'should not send registration email' do
          expect { call_request }.to_not change { ActionMailer::Base.deliveries.count }
        end

        context 'registration attempt' do
          before { call_request }

          it { should render_template 'new' }
        end
      end
    end

    describe '#update' do
      before do
        Devise::TokenGenerator.any_instance.stub(:generate).and_return(%w(REa8RXbZa6xxhyUos6Ku dc308b77c28c83a2226bdf8950dbca4826c99ded1f2630073d8a3d6c981a0883))
        subject.confirm!
        subject.send_reset_password_instructions
      end
      let(:call_request) { put :update, attrs }

      context 'when attributes are valid then password change attempt' do
        let(:attrs) { {user: {reset_password_token: 'REa8RXbZa6xxhyUos6Ku', password: 'secret', password_confirmation: 'secret'}} }
        before { call_request }

        it { expect(response).to redirect_to user_root_path }
        it 'should display correct flash message' do
          expect(flash[:notice]).to eq I18n.t('devise.passwords.updated')
        end
      end

      context 'when attributes are invalid then password change attempt' do
        let(:attrs) { {user: {reset_password_token: 'REa8RXbZa6xxhyUos6Ku', password: 'secret', password_confirmation: 'error'}} }
        before { call_request }

        it { should render_template 'edit' }
      end
    end
  end
end
