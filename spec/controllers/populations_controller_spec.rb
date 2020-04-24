require 'rails_helper'

RSpec.describe PopulationsController, type: :controller do
  render_views

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    before do
      allow(Population).to receive(:get).with('1900').and_return(76_212_168)
    end

    it 'returns http success' do
      get :show, params: { year: 1900 }
      expect(response).to be_successful
    end

    it 'returns a population for a date' do
      get :show, params: { year: 1900 }
      aggregate_failures do
        expect(response.content_type).to eq('text/html')
        expect(response.body).to include('Population: 76212168')
      end
    end
  end
end
