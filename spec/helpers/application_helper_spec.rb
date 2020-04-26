require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#exact_or_calculated' do
    let(:years) { [1990] }

    it 'returns "exact" for known population data' do
      expect(helper.exact_or_calculated(years, 1990)).to eq('exact')
    end

    it 'returns "calculated" for calculated population query' do
      expect(helper.exact_or_calculated(years, 2500)).to eq('calculated')
    end
  end

  describe '#model_checked' do
    it 'returns checked=checked for Exponential input with Exponential selected' do
      expect(helper.model_checked('Exponential', model: 'Exponential')).to eq(' checked="checked"')
    end

    it 'returns checked=checked for Logistical input with Logistical selected' do
      expect(helper.model_checked('Logistical', model: 'Logistical')).to eq(' checked="checked"')
    end

    it 'returns checked=checked for Logistical input with nothing selected' do
      expect(helper.model_checked('Logistical', {})).to eq(' checked="checked"')
    end

    it 'returns "" for Exponential input with nothing selected' do
      expect(helper.model_checked('Exponential', {})).to eq('')
    end

    it 'returns "" for Exponential input with Logistical selected' do
      expect(helper.model_checked('Exponential', model: 'Logistical')).to eq('')
    end

    it 'returns "" for Logistical input with Exponential selected' do
      expect(helper.model_checked('Logistical', model: 'Exponential')).to eq('')
    end
  end
end
