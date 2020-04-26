require 'rails_helper'

RSpec.describe Log, type: :model do
  let(:log) { FactoryBot.build(:log) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(log).to be_valid
    end

    it 'requires a query' do
      log.query = nil
      aggregate_failures do
        expect(log).to be_invalid
        expect(log.errors[:query]).to be_present
      end
    end

    it 'requires an answer' do
      log.answer = nil
      aggregate_failures do
        expect(log).to be_invalid
        expect(log.errors[:answer]).to be_present
      end
    end
  end

  describe '#for_dashboard' do
    before do
      FactoryBot.create(:log, :_1990)
      FactoryBot.create(:log)
    end

    it 'returns logs with non-blank queries' do
      expect(Log.for_dashboard.size).to eq(1)
    end
  end

  describe '#log!' do
    it 'does not log a blank year query' do
      expect { Log.log!(1, {}) }.to_not change(Log, :count)
    end

    it 'logs a valid query' do
      expect { Log.log!(1, {year: 1990}) }.to change(Log, :count).by(1)
    end
  end
end
