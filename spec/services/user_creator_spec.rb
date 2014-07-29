require 'spec_helper'

describe UserCreator do
  describe '#process' do
    let(:perform) { UserCreator.new(user).perform! }

    context 'when user is correct' do
      let(:user) { User.new(attributes_for(:user), as: :user) }

      it 'should create user' do
        expect { perform }.to change { User.count }.from(0).to(1)
      end

      it 'should create answer' do
        expect { perform }.to change { Answer.count }.from(0).to(1)
      end

      it 'should return created user' do
        expect(perform).to eq User.last
      end
    end

    context 'when user is not valid' do
      let(:user) { User.new(attributes_for(:user, email: nil), as: :user) }

      it 'should not create user' do
        expect { perform }.not_to change { User.count }
      end

      it 'should not create answer' do
        expect { perform }.not_to change { Answer.count }
      end

      it 'should return false' do
        expect(perform).to be false
      end
    end
  end
end
