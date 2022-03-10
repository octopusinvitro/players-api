# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'

require_relative 'api/game'
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

  get '/players' do
    fields = filter_player_fields

    if fields.empty?
      status(:bad_request)
      message = "Wrong filters, allowed fields: #{API::Player::FILTER_FIELDS}"
      return { errors: { players: [message] } }.to_json
    end

    players = API::Player.filter(fields)
    return { errors: { players: ["#{status(:not_found)} Not found"] } }.to_json if players.empty?

    { players: }.to_json
  end

  post '/games' do
    fields = allowed_game_fields
    game = API::Game.new(
      winner: API::Player.find_by(fields[:winner]),
      loser: API::Player.find_by(fields[:loser])
    )

    if game.save
      { game: game.jsonify }.to_json
    else
      status :bad_request
      { errors: game.errors.messages }.to_json
    end
  end

  private

  def allowed_player_fields
    payload.slice(*API::Player::ALLOWED_FIELDS)
  end

  def filter_player_fields
    sliced = params.slice(*API::Player::FILTER_FIELDS)
    JSON.parse(sliced.to_json, symbolize_names: true)
  end

  def allowed_game_fields
    payload.slice(*API::Game::ALLOWED_FIELDS)
  end

  def payload
    JSON.parse(request.body.read, symbolize_names: true)
  end
end
