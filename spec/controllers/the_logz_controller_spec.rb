require 'rails_helper'

RSpec.describe TheLogzController, type: :controller do
  render_views

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to be_successful
    end

    context 'with data' do
      before { FactoryBot.create(:log, :_1990) }

      it 'returns http success' do
        get :index
        aggregate_failures do
          expect(response.body).to include('1990')
          expect(response.body).to include('248709873')
        end
      end
    end
  end
end
