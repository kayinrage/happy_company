require 'spec_helper'

describe Chart do
  before { Timecop.freeze(Time.parse('27-07-2014')) }
  after { Timecop.return }

  describe '.params_processing' do
    let(:perform) { Chart.params_processing(params) }

    context 'when type is "user" and params have "user_ids"' do
      let(:params) { {'time' => 'month', 'type' => 'users', 'user_ids' => %w(5 4)} }

      it 'should returns correct params' do
        expect(perform).to eq({type: 'users', time: 'month', group_ids: [], user_ids: %w(5 4), parent_group_ids: []})
      end
    end

    context 'when type is "groups" and params have "parent_group_ids" and "user_ids"' do
      let(:params) { {'time' => 'week', 'type' => 'groups', 'user_ids' => %w(1 4), 'parent_group_ids' => %w(2)} }

      it 'should returns correct params' do
        expect(perform).to eq({type: 'groups', time: 'week', group_ids: [], user_ids: [], parent_group_ids: %w(2)})
      end
    end

    context 'when type is "groups" and params have "parent_group_ids", "user_ids" and "group_ids"' do
      let(:params) { {'time' => 'week', 'type' => 'groups', 'user_ids' => %w(1 4), 'parent_group_ids' => %w(2), 'group_ids' => %w(1 2)} }

      it 'should returns correct params' do
        expect(perform).to eq({type: 'groups', time: 'week', group_ids: %w(1 2), user_ids: [], parent_group_ids: %w(2)})
      end
    end
  end

  describe '.for_current_user' do
    let(:user) { create(:user) }
    let!(:answer_1) { create(:answer, user: user, date: Date.today - 2.days, result: 1) }
    let!(:answer_2) { create(:answer, user: user, date: Date.today - 1.days, result: 2) }
    let!(:answer_3) { create(:answer, user: user, date: Date.today, result: 3) }
    let(:perform) { Chart.for_current_user(user) }

    it 'should returns chart with correct options' do
      expect(perform.options).to eq({'height' => 400,
                                     'colors' => ['#00b0bc'],
                                     'backgroundColor' => '#fcffff',
                                     'title' => 'Your last 30 days',
                                     'vAxis' => {viewWindow: {min: 0, max: 3}, format: '#', gridlines: {count: 4}}})
    end

    it 'should returns chart with correct data_table dates' do
      expect(perform.data_table.rows.map { |a| a.first.v }).to eq %w(2014-07-25 2014-07-26 2014-07-27)
    end

    it 'should returns chart with correct data_table values' do
      expect(perform.data_table.rows.map { |a| a.last.v }).to eq [1, 2, 3]
    end
  end

  describe '.for_admin' do
    before do
      create(:membership, user: user_1, group: group_1)
      create(:membership, user: user_2, group: group_2)
      create(:answer, user: user_1, date: Date.today - 2.days, result: 1)
      create(:answer, user: user_1, date: Date.today - 1.days, result: 2)
      create(:answer, user: user_1, date: Date.today, result: 3)
      create(:answer, user: user_2, date: Date.today - 2.days, result: 0)
      create(:answer, user: user_2, date: Date.today - 1.days, result: 1)
      create(:answer, user: user_2, date: Date.today, result: 2)
    end
    let(:user_1) { create(:user, first_name: 'Irek', last_name: 'Happy') }
    let(:user_2) { create(:user, first_name: 'Monika', last_name: 'Happy') }
    let(:group_1) { create(:group, name: 'Selleo') }
    let(:group_2) { create(:group, name: 'RubyArt') }

    let(:perform) { Chart.for_admin(params) }

    context 'when params has type "users", time "month" and "user_ids"' do
      let(:params) { {type: 'users', time: 'month', group_ids: [], user_ids: [user_1.id.to_s, user_2.id.to_s], parent_group_ids: []}.with_indifferent_access }

      it 'should returns chart with correct options' do
        expect(perform.options).to eq({'height' => 400,
                                       'title' => 'Last 30 days',
                                       'vAxis' => {viewWindow: {min: 0, max: 3}, format: '#', gridlines: {count: 4}}})
      end

      it 'should returns chart with correct data_table cols' do
        expect(perform.data_table.cols).to eq [{type: 'string', label: 'Day'},
                                               {type: 'number', label: 'Irek Happy'},
                                               {type: 'number', label: 'Monika Happy'}]
      end

      it 'should returns chart with correct data_table rows first values' do
        expect(perform.data_table.rows.map { |a| a.first.v }).to eq (Date.parse('2014-06-26')..Date.parse('2014-07-26')).map(&:to_s)
      end

      it 'should returns chart with correct data_table rows second values' do
        expect(perform.data_table.rows.map { |a| a[1].v }).to eq([-1] * 29 + [1, 2])
      end

      it 'should returns chart with correct data_table rows second values' do
        expect(perform.data_table.rows.map { |a| a[2].v }).to eq([-1] * 29 + [0, 1])
      end
    end

    context 'when params has type "groups", time "week" and "group_ids"' do
      before do
        create(:membership, user: user_3, group: group_1)
        create(:answer, user: user_3, date: Date.today - 2.days, result: 3)
        create(:answer, user: user_3, date: Date.today - 1.days, result: 3)
        create(:answer, user: user_3, date: Date.today, result: 3)
      end
      let(:user_3) { create(:user) }

      let(:params) { {type: 'groups', time: 'week', group_ids: [group_1.id.to_s, group_2.id.to_s], user_ids: [], parent_group_ids: []}.with_indifferent_access }

      it 'should returns chart with correct options' do
        expect(perform.options).to eq({'height' => 400,
                                       'title' => 'Last 7 days',
                                       'vAxis' => {viewWindow: {min: 0, max: 3}, format: '#', gridlines: {count: 4}}})
      end

      it 'should returns chart with correct data_table cols' do
        expect(perform.data_table.cols).to eq [{type: 'string', label: 'Day'},
                                               {type: 'number', label: 'Selleo'},
                                               {type: 'number', label: 'RubyArt'}]
      end

      it 'should returns chart with correct data_table rows first values' do
        expect(perform.data_table.rows.map { |a| a.first.v }).to eq (Date.parse('2014-07-19')..Date.parse('2014-07-26')).map(&:to_s)
      end

      it 'should returns chart with correct data_table rows second values' do
        expect(perform.data_table.rows.map { |a| a[1].v }).to eq([-1.0] * 6 + [2.0, 2.5])
      end

      it 'should returns chart with correct data_table rows second values' do
        expect(perform.data_table.rows.map { |a| a[2].v }).to eq([-1.0] * 6 + [0.0, 1.0])
      end
    end
  end
end
