require 'rails_helper'

RSpec.describe 'The Logz Dashboard', type: :system do
  describe 'User visits the queries logs' do
    let(:log) { instance_double('Log') }
    let(:now) { Time.zone.now }

    before do
      allow(Log).to receive_message_chain(:order, :limit).with(created_at: :desc).with(100).and_return([log])
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

  describe 'User visits the exact queries counts' do
    let(:population) { double('Population', queries: 2) }

    before do
      allow(Population).to receive(:exact_queries).and_return([population])
      allow(population).to receive(:year).and_return('1990')
      allow(population).to receive(:population).and_return('248709873')
      visit exact_queries_path
    end

    it 'Shows a log' do
      aggregate_failures do
        expect(page).to have_css('td', text: '1990')
        expect(page).to have_css('td', text: '248709873')
        expect(page).to have_css('td', text: '2')
      end
    end
  end
end
