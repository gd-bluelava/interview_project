require 'rails_helper'

RSpec.describe 'Get population by year', type: :system do
  before do
    allow(Population).to receive(:get).with(nil, nil).and_return(0)
  end

  describe 'User enters a valid year' do
    context 'with a known population' do
      before do
        allow(Population).to receive(:get).with(1990, nil).and_return(248_709_873)
      end

      it 'shows a population figure for 1900' do
        visit populations_path
        fill_in 'year', with: 1990
        click_on 'Submit'

        expect(page).to have_css('h3', text: 'Population: 248709873')
      end
    end

    context 'with an unknown population defaulting to Logistical' do
      before { allow(Population).to receive(:get).with(1991, 'Logistical').and_return(265_217_999) }

      it 'shows a population figure for 1991' do
        visit populations_path
        fill_in 'year', with: 1991
        click_on 'Submit'

        expect(page).to have_css('h3', text: 'Population: 265217999')
      end
    end

    context 'with an unknown population choosing Exponential' do
      before { allow(Population).to receive(:get).with(1991, 'Exponential').and_return(271_093_761) }

      it 'shows a population figure for 1991' do
        visit populations_path
        fill_in 'year', with: 1991
        page.find('body').click
        choose 'Exponential'
        click_on 'Submit'

        expect(page).to have_css('h3', text: 'Population: 271093761')
      end
    end
  end

  describe 'User attacks' do
    before { allow(Population).to receive(:get).with(0, nil).and_return(0) }

    it 'handles an XSS attack' do
      visit populations_path
      fill_in 'year', with: '"><script>alert("XSS")</script>&'
      click_on 'Submit'

      expect(page).to have_css('h3', text: 'Population: 0')
    end
  end
end
