require 'rails_helper'

RSpec.describe 'Locations API', type: :request do
  let!(:locations) { create_list(:location, 10) }
  let(:location_id) { locations.first.id }

  describe 'GET /locations' do
    before { get '/locations' }

    it 'returns locations' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /locations/:id' do
    before { get "/locations/#{location_id}" }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(location_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:location_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Location/)
      end
    end
  end

  describe 'POST /locations' do
    let(:valid_attributes) { { name: "trabajo",
                               address: "Calle Nuñez de Balboa, 120",
                               postcode: "28006",
                               city: "Madrid",
                               country: "España"}
    ActiveJob::Base.queue_adapter = :test

    context 'when the request is valid' do

      before do
        intercept_exist
        post '/locations', params: valid_attributes
      end

      it 'creates a todo' do
        expect(json['name']).to eq('trabajo')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it "enqeue geocoding job" do
        expect(GeocodingJob).to have_been_enqueued
      end
    end

    context 'when the request is invalid' do
      before { post '/locations', params: { name: "trabajo",
                                            city: "Madrid",
                                            country: "España"
       } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Address can't be blank\"/)
      end
    end
  end

end