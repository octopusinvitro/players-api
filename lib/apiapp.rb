# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'

require_relative 'api/player'

class APIapp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  before do
    content_type 'application/json'
  end

  get '/' do
    { status: status(:ok) }.to_json
  end

  post '/players' do
    player = API::Player.new(allowed_player_fields)

    if player.save
      { player: player.jsonify }.to_json
    else
      status :bad_request
      { errors: player.errors.messages }.to_json
    end
  end

  private

  def allowed_player_fields
    payload.slice(*API::Player::ALLOWED_FIELDS)
  end

  def payload
    JSON.parse(request.body.read, symbolize_names: true)
  end
end
