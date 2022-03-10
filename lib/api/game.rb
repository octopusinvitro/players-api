# frozen_string_literal: true

require 'sinatra/activerecord'

require_relative 'player'

module API
  class Game < ActiveRecord::Base
    belongs_to :winner, class_name: 'Player', inverse_of: :games_won
    belongs_to :loser, class_name: 'Player', inverse_of: :games_lost

    validate :existence

    after_initialize :recalculate_score, if: :valid?

    ALLOWED_FIELDS = %i[winner loser].freeze

    def jsonify
      {
        winner: {
          firstname: winner.firstname, lastname: winner.lastname,
          score: winner.score
        },
        loser: {
          firstname: loser.firstname, lastname: loser.lastname,
          score: loser.score
        }
      }
    end

    private

    def existence
      errors.add(:winner, 'inexistent') unless player_exists?(winner)
      errors.add(:loser, 'inexistent') unless player_exists?(loser)
    end

    def player_exists?(player)
      player&.id && Player.find(player.id)
    end

    def recalculate_score
      giveaway = (loser.score * 0.1).round
      loser.score -= giveaway
      winner.score += giveaway
    end
  end
end
