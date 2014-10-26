require 'rails_helper'

describe ApiAnswerUpdater do
  describe '#perform!' do
    let(:perform) { described_class.new(answer, params).perform! }

    context 'when params are correct' do
      let(:params) { '3' }

      context 'and answer is correct' do
        let(:answer) { create(:answer, result: 1, date: Date.today) }

        it "should change answer's result" do
          expect { perform }.to change { answer.reload.result }.from(1).to(3)
        end

        it 'should return success with correct message' do
          expect(perform).to eq(status: 'success', message: 'Answer has been successfully saved!')
        end
      end

      context 'and answer is outdated' do
        let(:answer) { create(:answer, result: 1, date: Date.yesterday) }

        it "should not change answer's result" do
          expect { perform }.not_to change { answer.reload.result }
        end

        it 'should return fail with correct message' do
          expect(perform).to eq(status: 'fail', message: 'You cannot answer outdated question!')
        end
      end

      context 'and answer is answered' do
        let(:answer) { create(:answer, result: 1, date: Date.today, answered: true) }

        it "should not change answer's result" do
          expect { perform }.not_to change { answer.reload.result }
        end

        it 'should return fail with correct message' do
          expect(perform).to eq(status: 'fail', message: 'You cannot change your answer through link! If you want to change your answer then please use web application.')
        end
      end
    end

    context 'when answer is correct but params are not correct because' do
      let(:answer) { create(:answer, result: 1, date: Date.today) }

      context 'result is wrong' do
        let(:params) { '5' }

        it "should not change answer's result" do
          expect { perform }.not_to change { answer.reload.result }
        end

        it 'should return fail with correct message' do
          expect(perform).to eq(status: 'fail', message: 'Result should be within range (0..3)')
        end
      end
    end
  end
end
