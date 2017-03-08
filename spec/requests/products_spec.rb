require 'rails_helper'

RSpec.describe 'Products API', type: :request do

  describe 'GET /products' do

    context 'when price lower than 500' do
      let!(:products) { create_list(:product, 4, price: 450) }
      let!(:expensive_products) { create_list(:product, 15, price: 550) }
      before { get '/products?filter[price_lt]=500' }

      it 'returns products' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['data'].size).to eq 4
      end
    end

    context 'when category is specified' do
      let!(:markups) { create_list(:product, 4, category: 'markup') }
      let!(:tools) { create_list(:product, 5, category: 'tools') }
      let!(:brushes) { create_list(:product, 6, category: 'brushes') }

      context 'get one category' do
        before { get '/products?filter[category_eq]=tools' }

        it 'returns products' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq 5
        end
      end

      context 'get multi categories' do
        before { get '/products?filter[category_in]=markup,brushes' }

        it 'returns products' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq(4 + 6)
        end
      end
    end

    context 'with sorting options' do
      let!(:product_1) { create(:product, price: 300) }
      let!(:product_2) { create(:product, price: 400) }
      let!(:product_3) { create(:product, price: 500) }

      context 'ASC' do
        before { get '/products?sort=price' }

        it 'returns products ascendingly' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq 3
          expect(json['data'].last['attributes']['price']).to eq 500
        end
      end

      context 'DESC' do
        before { get '/products?sort=-price' }

        it 'returns products ascendingly' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq 3
          expect(json['data'].last['attributes']['price']).to eq 300
        end
      end
    end

    context 'pagination options' do
      let!(:products) { create_list(:product, 30) }

      context 'default' do
        before { get '/products' }

        it 'returns products with default amount' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq 25
        end

        it 'has pagination links' do
          json = JSON.parse(response.body)
          expect(json['links']).not_to be_empty
          expect(json['links']['self']).not_to be_empty
          expect(json['links']['next']).not_to be_empty
          expect(json['links']['last']).not_to be_empty
          expect(json['links']['prev']).to eq nil
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'first page' do
        let(:new_page_size) { 7 }
        before { get "/products?page[number]=1&page[size]=#{new_page_size}" }

        it 'returns products with default amount' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq new_page_size
        end

        it 'has pagination links' do
          json = JSON.parse(response.body)
          expect(json['links']).not_to be_empty
          expect(json['links']['self']).not_to be_empty
          expect(json['links']['next']).not_to be_empty
          expect(json['links']['last']).not_to be_empty
          expect(json['links']['prev']).to eq nil
          expect(json['links']['first']).to eq nil
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'middle page' do
        let(:new_page_size) { 10 }
        before { get "/products?page[number]=2&page[size]=#{new_page_size}" }

        it 'returns products with default amount' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq new_page_size
        end

        it 'has pagination links' do
          json = JSON.parse(response.body)
          expect(json['links']).not_to be_empty
          expect(json['links']['self']).not_to be_empty
          expect(json['links']['first']).not_to be_empty
          expect(json['links']['prev']).not_to be_empty
          expect(json['links']['next']).not_to be_empty
          expect(json['links']['last']).not_to be_empty
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'last page' do
        # Total is 30 products, query 20 products with one 20 offset
        before { get "/products?page[number]=2&page[size]=20" }

        it 'returns products with default amount' do
          json = JSON.parse(response.body)
          expect(json).not_to be_empty
          expect(json['data'].size).to eq 10
        end

        it 'has pagination links' do
          json = JSON.parse(response.body)
          expect(json['links']).not_to be_empty
          expect(json['links']['self']).not_to be_empty
          expect(json['links']['prev']).not_to be_empty
          expect(json['links']['next']).to eq nil
          expect(json['links']['last']).to eq nil
        end

        it 'returns status 200' do
          expect(response).to have_http_status(200)
        end
      end

    end

    context 'no params' do
      let!(:products) { create_list(:product, 30) }

      before { get '/products' }

      it 'returns products with default amount' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['data'].size).to eq 25
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

  describe 'Error handling' do
    before {
      ProductQueryService.any_instance.stub(:call).and_raise('invalid params')
      get '/products'
    }

    it "return 500 response" do
        json = JSON.parse(response.body)
        expect(json['data']).to eq nil
        expect(json['errors']).not_to be_empty
        expect(json['errors']['status']).to eq 500
        expect(json['errors']['title']).to eq 'internal error occurs'
        expect(json['errors']['detail']).to eq 'invalid params'
    end
  end

end
