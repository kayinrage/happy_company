require 'rails_helper'

describe Answer do
  it 'has valid factory' do
    expect(build(:answer)).to be_valid
  end

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:date) }
  it { should validate_uniqueness_of(:date).scoped_to(:user_id) }
  it { should validate_inclusion_of(:result).in_array([3, 2, 1, 0]) }

  describe '#save' do
    let(:answer) { build(:answer) }

    it 'should has set secret' do
      answer.save
      expect(answer.reload.secret).not_to be nil
    end

    context 'when result is explicit set to 3' do
      let(:answer) { build(:answer, result: 3) }
      before { answer.save }

      it 'should has result set to 3' do
        expect(answer.result).to eq 3
      end
    end

    context 'when result is not set' do
      let(:answer) { build(:answer, result: nil) }
      before { answer.save }

      it 'should has result set to 1' do
        expect(answer.result).to eq 1
      end
    end

    context 'when result is not set but previous answer for user has result 2' do
      let(:user) { create(:user) }
      let!(:prev_answer) { create(:answer, user: user, result: 2, date: Date.today) }
      let(:answer) { build(:answer, user: user, result: nil, date: Date.tomorrow) }
      before { answer.save }

      it 'should has result set to 2' do
        expect(answer.result).to eq 2
      end
    end
  end

  describe '#update_by_user' do
    let(:perform) { answer.update_by_user(params) }

    context 'when answer is correct and not outdated' do
      let!(:answer) { create(:answer, result: 1, date: Date.today) }

      context 'and params are correct' do
        let(:params) { {result: 3} }

        it "should change answer's result" do
          expect { perform }.to change { answer.reload.result }.from(1).to(3)
        end

        it "should return 3" do
          expect(perform).to be 3
        end
      end

      context 'and params has wrong result' do
        let(:params) { {result: 10} }

        it "should not change answer's result" do
          expect { perform }.not_to change { answer.reload.result }
        end

        it 'should return false' do
          expect(perform).to be false
        end
      end
    end

    context 'when answer is correct but answer is outdated' do
      let!(:answer) { create(:answer, result: 1, date: Date.yesterday) }
      let(:params) { {result: 3} }

      it "should not change answer's result" do
        expect { perform }.not_to change { answer.reload.result }
      end

      it 'should return false' do
        expect(perform).to be false
      end
    end
  end

  context '.result_dictionary' do
    it 'should return correct text for 0' do
      expect(described_class.result_dictionary[0]).to eq 'No, this day was a big disappointment :('
    end

    it 'should return correct text for 1' do
      expect(described_class.result_dictionary[1]).to eq 'No, it was an average day for me :/'
    end

    it 'should return correct text for 2' do
      expect(described_class.result_dictionary[2]).to eq 'Yes, this day was nice :)'
    end

    it 'should return correct text for 3' do
      expect(described_class.result_dictionary[3]).to eq "Yes, I'm very happy about this day :D"
    end

    it 'should return nil for 4 (and other number)' do
      expect(described_class.result_dictionary[4]).to be nil
    end
  end

  context '#outdated?' do
    context 'when date is today' do
      let(:answer) { create(:answer, date: Date.today) }

      it 'should return false' do
        expect(answer.outdated?).to be false
      end
    end

    context 'when date is yesterday' do
      let(:answer) { create(:answer, date: Date.yesterday) }

      it 'should return true' do
        expect(answer.outdated?).to be true
      end
    end
  end

  context '#selected?' do
    context 'when answer is not answered' do
      let(:answer) { create(:answer, result: 1, date: Date.today) }

      context 'and param is the same as result' do
        it 'should return false' do
          expect(answer.selected?(1)).to be false
        end
      end

      context 'and param is the different as result' do
        it 'should return false' do
          expect(answer.selected?(2)).to be false
        end
      end
    end

    context 'when answer is answered' do
      let(:answer) { create(:answer, result: 1, date: Date.today, answered: true) }

      context 'and param is the same as result' do
        it 'should return true' do
          expect(answer.selected?(1)).to be true
        end
      end

      context 'and param is the different as result' do
        it 'should return false' do
          expect(answer.selected?(2)).to be false
        end
      end
    end
  end

  context '#api_link' do
    let(:answer) { create(:answer, date: Date.today) }

    it 'should return correct link' do
      expect(answer.api_link(3)).to eq "http://localhost:3000/api/answers/#{answer.id}?secret=#{answer.secret}&result=3"
    end
  end
end
