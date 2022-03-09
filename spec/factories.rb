# frozen_string_literal: true

require 'api/game'
require 'api/player'
require 'api/rank'

def game(fields = {})
  winner = player(firstname: 'Winner')
  loser = player(lastname: 'Loser')
  API::Game.new({ winner:, loser: }.merge(fields))
end

def player(fields = {})
  default = {
    firstname: 'firstname', lastname: 'lastname',
    nationality: 'nationality', birthdate: '1900-01-01'
  }
  API::Player.new(default.merge(fields))
end

def rank(fields = {})
  API::Rank.new({ name: API::Rank::UNRANKED }.merge(fields))
end
