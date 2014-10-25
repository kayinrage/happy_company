require 'rails_helper'

describe NotificationMailer, type: :mailer do
  describe '#everyday_question' do
    let(:email) { described_class.everyday_question(user, answer) }
    let(:user) { create(:user, email: 'irek@happy.com') }
    let(:answer) { build(:answer, secret: '1234567890') }

    it { expect(email).to deliver_to('irek@happy.com') }
    it { expect(email).to deliver_from('no-replay@happycompany.com') }
    it { expect(email).to have_subject('Are you happy today?') }
    it { expect(email).to have_body_text('Are you happy today?') }
    it { expect(email).to have_body_text("Hello #{user.first_name} #{user.last_name}!") }
    it { expect(email).to have_body_text('http://localhost:3000/api/answers/?secret=1234567890&amp;result=2') }
  end
end
