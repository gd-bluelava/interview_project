require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:years) { [1990] }

  describe '#exact_or_calculated' do
    it 'returns "exact" for known population data' do
      expect(helper.exact_or_calculated(years, 1990)).to eq('exact')
    end

    it 'returns "calculated" for calculated population query' do
      expect(helper.exact_or_calculated(years, 2500)).to eq('calculated')
    end
  end
end
