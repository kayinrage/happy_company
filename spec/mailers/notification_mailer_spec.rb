require 'spec_helper'

describe NotificationMailer, type: :mailer do
  describe '#everyday_question' do
    let(:email) { described_class.everyday_question(user, answer) }
    let(:user) { create(:user, email: 'irek@happy.com') }
    let(:answer) { build(:answer, secret: '1234567890') }

    it { email.should deliver_to('irek@happy.com') }
    it { email.should deliver_from('no-replay@happycompany.com') }
    it { email.should have_subject('Are you happy today?') }
    it { email.should have_body_text('Are you happy today?') }
    it { email.should have_body_text("Hello #{user.first_name} #{user.last_name}!") }
    it { email.should have_body_text('http://localhost:3000/api/answers/?secret=1234567890&amp;result=2') }
  end
end
