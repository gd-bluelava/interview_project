require 'rails_helper'

RSpec.describe Population, type: :model do
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
        expect(described_class.get(1972)).to be_zero
      end

      describe '.approximate is not called' do
        before { FactoryBot.create(:population, :_1900) }

        it 'unless year is between two other years' do
          expect(described_class).to_not receive(:approximate)
          described_class.get(1955)
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
          expect(described_class.get(1900)).to eq(76_212_168)
          expect(described_class.get(1990)).to eq(248_709_873)
        end
      end

      it 'accepts a year that is before earliest known and returns zero' do
        aggregate_failures do
          expect(described_class.get(1800)).to eq(0)
          expect(described_class.get(0)).to eq(0)
          expect(described_class.get(-1000)).to eq(0)
        end
      end

      it 'accepts a year after latest known and returns latest known population' do
        aggregate_failures do
          expect(described_class.get(2000)).to eq(248_709_873)
          expect(described_class.get(200_000)).to eq(248_709_873)
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
end
