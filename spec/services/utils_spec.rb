require 'spec_helper'

describe Utils do
  describe '.generate_secret' do
    context 'when no attribute it passed' do
      it 'should generate code from 16 characters' do
        expect(Utils.generate_secret.size).to eq 16
      end
    end

    context 'when attribute is passed and is equal 4' do
      it 'should generate code from 4 characters' do
        expect(Utils.generate_secret(4).size).to eq 4
      end
    end
  end

  describe '.mailer_host' do
    it 'should return correct host' do
      expect(Utils.mailer_host).to eq 'localhost:3000'
    end
  end

  describe '.api_response' do
    it 'should return hash with correct key-values' do
      expect(Utils.api_response('200', 'everything is awesome')).to eq({status: '200', message: 'everything is awesome'})
    end
  end

  describe '.add_membership_for_seed' do
    before do
      create(:group, name: 'Selleo')
      create(:group, name: 'RubyArt')
      create(:group, name: 'Ubisoft')
    end
    let!(:user) { create(:user, first_name: 'Irek') }
    let(:perform) { Utils.add_membership_for_seed('Irek', ['RubyArt', 'Selleo']) }

    it 'add two groups to user' do
      expect { perform }.to change { user.reload.groups.count }.from(0).to(2)
    end

    it 'second perform will not create not necessary memberships' do
      perform
      expect { perform }.not_to change { Membership.count }
    end
  end
end
