require 'rails_helper'

RSpec.describe TheLogzController, type: :controller do
  render_views

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to be_successful
    end

    context 'with data' do
      before do
        FactoryBot.create(:population, :_1990)
        FactoryBot.create(:log, :_1990)
      end

      it 'returns http success' do
        get :index
        aggregate_failures do
          expect(response.body).to include('1990')
          expect(response.body).to include('248709873')
          expect(response.body).to include('exact')
        end
      end
    end
  end

  describe 'GET #exact_queries' do
    it 'returns http success' do
      get :exact_queries
      expect(response).to be_successful
    end

    context 'with data' do
      before do
        FactoryBot.create(:population, :_1990)
        FactoryBot.create_list(:log, 2, :_1990)
      end

      it 'returns http success' do
        get :exact_queries
        aggregate_failures do
          expect(response.body).to include('1990')
          expect(response.body).to include('248709873')
          expect(response.body).to include('<td>2</td>')
        end
      end
    end
  end
end
