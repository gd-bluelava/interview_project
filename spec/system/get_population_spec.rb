require 'rails_helper'

RSpec.describe 'Get population by year', type: :system do
  describe 'User enters a valid year' do
    before do
      allow(Population).to receive(:get).with('1900').and_return(76_212_168)
    end

    it 'shows a population figure' do
      visit populations_path
      fill_in 'year', with: 1900
      click_on 'Submit'

      expect(page).to have_css('h3', text: 'Population: 76212168')
    end
  end
end
