require 'rails_helper'

describe User::ProfileController do
  render_views
  include_context 'user signed in'

  describe '#edit' do
    before { get :edit }

    it { should render_template 'edit' }
  end

  describe '#update' do
    let(:call_request) { get :update, user: params }

    context 'changing user data' do
      context 'when attributes are correct' do
        let(:params) { {email: 'batman@dc.com', first_name: 'Bruce', last_name: 'Wayne'} }

        it 'should save email' do
          expect { call_request }.to change { user.reload.email }
        end

        it 'should save first_name' do
          expect { call_request }.to change { user.reload.first_name }
        end

        it 'should save last_name' do
          expect { call_request }.to change { user.reload.last_name }
        end

        context 'after call_request' do
          before { call_request }

          it { should redirect_to edit_user_profile_path }
        end
      end

      context 'when attributes are wrong' do
        let(:params) { {email: '', first_name: 'Bruce', last_name: 'Wayne'} }

        it 'should not save changes' do
          expect { call_request }.not_to change { user.reload.first_name }
        end

        context 'after call_request' do
          before { call_request }

          it { should render_template 'edit' }
        end
      end
    end

    context 'changing password' do
      context 'when attributes are correct' do
        let(:params) { {password: 'top_secret', password_confirmation: 'top_secret'} }

        it 'should save email' do
          expect { call_request }.to change { user.reload.encrypted_password }
        end

        context 'after call_request' do
          before { call_request }

          it { should redirect_to edit_user_profile_path }
        end
      end

      context 'when attributes are wrong' do
        let(:params) { {password: 'top_secret', password_confirmation: ''} }

        it 'should not save changes' do
          expect { call_request }.not_to change { user.reload.encrypted_password }
        end

        context 'after call_request' do
          before { call_request }

          it { should render_template 'edit' }
        end
      end
    end
  end
end
