require 'rails_helper'

RSpec.describe Population, type: :model do
  describe 'MAX_YEAR' do
    it 'returns 2500' do
      expect(described_class::MAX_YEAR).to eq(2500)
    end
  end

  describe 'ALGOS' do
    it 'returns a list of algorithms' do
      expect(described_class::ALGOS).to eq(%w[None Logistical Exponential])
    end
  end

  context 'invalid' do
    describe 'negative data' do
      let(:population) { FactoryBot.build(:population, :invalid_negatives) }

      it 'has errors' do
        aggregate_failures do
          expect(population).to be_invalid
          expect(population.errors[:year]).to be_present
          expect(population.errors[:population]).to be_present
        end
      end
    end

    describe 'non-integer data' do
      let(:population) { FactoryBot.build(:population, :invalid_floats) }

      it 'has errors' do
        aggregate_failures do
          expect(population).to be_invalid
          expect(population.errors[:year]).to be_present
          expect(population.errors[:population]).to be_present
        end
      end
    end

    describe 'non-unique year' do
      before { FactoryBot.create(:population, :_1900) }

      it 'has errors' do
        new_population = FactoryBot.build(:population, :_1900)
        expect(new_population).to be_invalid
        expect(new_population.errors[:year]).to be_present
      end
    end
  end

  context 'with more than one population' do
    before do
      FactoryBot.create(:population, :_1990)
      FactoryBot.create(:population, :_1991)
    end

    describe '.min' do
      it 'returns the minimum year' do
        expect(described_class.min.year).to eq(1990)
      end
    end

    describe '.max' do
      it 'returns the maximum year' do
        expect(described_class.max.year).to eq(1991)
      end
    end
  end

  describe '.get' do
    context 'with no populations' do
      it 'returns zero' do
        expect(described_class.get(1972, nil)).to be_zero
      end

      describe '.approximate is not called' do
        before { FactoryBot.create(:population, :_1900) }

        it 'unless year is between two other years' do
          expect(described_class).to_not receive(:approximate)
          described_class.get(1955, nil)
        end
      end

      describe '.exponential is called' do
        before { FactoryBot.create(:population, :_1990) }

        it 'when year is after max know year and Exponential is chosen' do
          expect(described_class).to receive(:exponential)
          described_class.get(2000, 'Exponential')
        end
      end

      describe '.logistical is called' do
        before { FactoryBot.create(:population, :_1990) }

        it 'when year is after max know year and Logistical is chosen' do
          expect(described_class).to receive(:logistical)
          described_class.get(2000, 'Logistical')
        end
      end
    end

    context 'with some populations' do
      before do
        FactoryBot.create(:population, :_1900)
        FactoryBot.create(:population, :_1902)
        FactoryBot.create(:population, :_1990)
        FactoryBot.create(:population, :_2000)
      end

      it 'accepts a known year and returns correct population' do
        aggregate_failures do
          expect(described_class.get(1900, nil)).to eq(76_212_168)
          expect(described_class.get(1990, nil)).to eq(248_709_873)
        end
      end

      it 'accepts a year that is before earliest known and returns zero' do
        aggregate_failures do
          expect(described_class.get(1800, nil)).to eq(0)
          expect(described_class.get(0, nil)).to eq(0)
          expect(described_class.get(-1000, nil)).to eq(0)
        end
      end
    end
  end

  describe '.approximate' do
    before do
      FactoryBot.create(:population, :_1950)
      FactoryBot.create(:population, :_1960)
    end

    it 'returns an approximate population value' do
      aggregate_failures do
        expect(described_class.approximate(1951)).to eq(154_125_535)
        expect(described_class.approximate(1955)).to eq(165_324_486)
        expect(described_class.approximate(1959)).to eq(176_523_437)
      end
    end
  end

  describe '.clamp_year' do
    it 'returns nil' do
      expect(described_class.clamp_year(nil)).to_not be
    end

    it 'returns a clamped value' do
      aggregate_failures do
        expect(described_class.clamp_year(-1)).to eq(0)
        expect(described_class.clamp_year(1990)).to eq(1990)
        expect(described_class.clamp_year(2501)).to eq(2500)
      end
    end
  end

  describe '.exponential' do
    before { FactoryBot.create(:population, :_1990) }

    it 'returns an exponentially calculated population value' do
      aggregate_failures do
        expect(described_class.exponential(1991)).to eq(271_093_761)
        expect(described_class.exponential(2345)).to eq(4_809_498_399_058_283_144_488)
        expect(described_class.exponential(2500)).to eq(3_042_334_520_670_978_197_473_469_736)
      end
    end
  end

  describe '.logistic' do
    before { FactoryBot.create(:population, :_1990) }

    it 'returns a logistically calculated population value' do
      aggregate_failures do
        expect(described_class.logistical(1991)).to eq(265_217_999)
        expect(described_class.logistical(2000)).to eq(413_647_198)
        expect(described_class.logistical(2010)).to eq(563_656_435)
        expect(described_class.logistical(2025)).to eq(690_795_856)
        expect(described_class.logistical(2050)).to eq(743_285_779)
        expect(described_class.logistical(2099)).to eq(749_917_659)
      end
    end
  end

  describe '#exact_queries' do
    let(:result) { described_class.exact_queries[0] }

    before do
      FactoryBot.create(:population, :_1990)
      FactoryBot.create_list(:log, 2, :_1990)
    end

    it 'returns populations with logs counts using a join on year' do
      aggregate_failures do
        expect(result.year).to eq(1990)
        expect(result.population).to eq(248_709_873)
        expect(result.queries).to eq(2)
      end
    end
  end

  describe '#years' do
    before do
      FactoryBot.create(:population, :_1990)
      FactoryBot.create(:population, :_1991)
    end

    it 'returns population years' do
      expect(described_class.years).to eq([1990, 1991])
    end
  end
end
