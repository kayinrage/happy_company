require 'spec_helper'

describe HomeController do
  describe '#index' do
    context 'when user not logged in' do
      before { get :index }

      it { should render_template 'index' }
    end

    context 'when user logged in' do
      include_context 'user signed in'
      before { get :index }

      it { should redirect_to user_root_path }
    end
  end
end
