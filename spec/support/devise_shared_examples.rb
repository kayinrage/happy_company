shared_examples 'change password create valid attributes' do |type|
  context "when attributes are correct (emails is written with #{type} characters)" do
    let(:attrs) { {user: {email: type == 'downcase' ? subject.email : subject.email.upcase}} }

    it 'should send registration email' do
      expect { call_request }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    context 'registration attempt' do
      let(:tokens) { %w(REa8RXbZa6xxhyUos6Ku dc308b77c28c83a2226bdf8950dbca4826c99ded1f2630073d8a3d6c981a0883) }
      before do
        allow_any_instance_of(Devise::TokenGenerator).to receive(:generate).and_return(tokens)
        call_request
      end

      it { should redirect_to new_user_session_path }
      it 'should display correct flash message' do
        expect(flash[:notice]).to eq I18n.t('devise.passwords.send_instructions')
      end

      context 'registration email' do
        let(:email) { ActionMailer::Base.deliveries.last }

        it { expect(email).to deliver_to(subject.email) }
        it { expect(email).to deliver_from('no-replay@happycompany.com') }
        it { expect(email).to have_subject('Reset password instructions') }
        it { expect(email).to have_body_text("/users/password/edit?reset_password_token=REa8RXbZa6xxhyUos6Ku") }
      end
    end
  end
end
