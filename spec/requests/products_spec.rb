require 'rails_helper'

RSpec.describe 'Products API', type: :request do

  describe 'GET /products' do
    context 'when price lower than 500' do
      before { get '/products?filter[price_lt]=500' }
    end

    context 'no params' do
      let!(:products) { create_list(:product, 30) }
      let(:existing_id) { products.last.id }

      before { get '/products' }

      it 'returns products' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['data'].size).to eq 25
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'no data' do
      before { get '/products' }

      it 'returns empty results' do
        json = JSON.parse(response.body)
        expect(json['data'].size).to eq 0
      end

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /products/:id' do
    let!(:products) { create_list(:product, 30) }
    let(:existing_id) { products.last.id }

    before { get "/products/#{existing_id}" }

    context 'when product exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the product' do
        json = JSON.parse(response.body)
        expect(json['data']['id']).to eq existing_id.to_s
        expect(json['data']['attributes']['name']).to eq Product.last.name
      end
    end

    context 'when product does not exist' do
      before { get "/products/0" }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns the product' do
        json = JSON.parse(response.body)
        expect(json).to eq({})
      end
    end
  end
end
