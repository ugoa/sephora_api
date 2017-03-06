require 'rails_helper'


RSpec.describe 'Products API', type: :request do
  let!(:products) { create_list(:product, 10) }

  describe 'GET /products' do
    before { get '/products' }

    it 'returns products' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).not_to eq 10
    end

    it 'returns status 200' do
      expect(response).to have_http_status(200)
    end
  end
end
