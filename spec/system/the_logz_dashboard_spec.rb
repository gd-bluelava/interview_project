require 'rails_helper'

RSpec.describe 'The Logz Dashboard', type: :system do
  describe 'User visits the page' do
    let(:log) { instance_double('Log') }
    let(:now) { Time.zone.now }

    before do
      allow(Log).to receive(:order).with(created_at: :desc).and_return([log])
      allow(log).to receive(:query).and_return('1990')
      allow(log).to receive(:answer).and_return('248709873')
      allow(log).to receive(:created_at).and_return(now)
      allow_any_instance_of(ApplicationHelper).to receive(:exact_or_calculated).and_return('exact')
      visit the_logz_path
    end

    it 'Shows a log' do
      aggregate_failures do
        expect(page).to have_css('td', text: '1990')
        expect(page).to have_css('td', text: '248709873')
        expect(page).to have_css('td', text: now)
        expect(page).to have_css('td', text: 'exact')
      end
    end
  end
end
