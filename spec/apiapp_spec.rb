# frozen_string_literal: true

require 'apiapp'

require_relative 'factories'

RSpec.describe APIapp do
  let(:app) { described_class.new }
  let(:body) { JSON.parse(last_response.body, symbolize_names: true) }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe 'show home' do
    it 'loads OK check' do
      get '/'
      expect(last_response).to be_ok
      expect(body).to eq(status: 200)
    end
  end

  describe 'create player' do
    let(:player) do
      {
        firstname: 'firstname',
        lastname: 'lastname',
        nationality: 'nationality',
        birthdate: '1878-11-07'
      }
    end

    def create_player(fields = {})
      rank.save
      post '/players', player.merge(fields).to_json, headers
    end

    context 'when success' do
      it 'is successfull' do
        create_player
        expect(last_response).to be_ok
      end

      it 'creates a player' do
        create_player
        expect(API::Player).to exist
      end

      it 'returns created player' do
        create_player
        expect(body[:player]).to include(player.except(:birthdate))
      end
    end

    context 'when failure' do
      it 'is unsuccessfull' do
        create_player(firstname: nil)
        expect(last_response).to be_bad_request
      end

      it 'does not create a player' do
        create_player(nationality: nil)
        expect(API::Player).to_not exist
      end

      it 'returns all errors' do
        create_player(birthdate: nil)
        expect(body[:errors][:birthdate].count).to eq(2)
      end
    end
  end
end
