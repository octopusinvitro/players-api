# frozen_string_literal: true

require 'sinatra/activerecord'

require_relative 'player'

module API
  class Game < ActiveRecord::Base
    belongs_to :winner, class_name: 'Player', inverse_of: :games_won
    belongs_to :loser, class_name: 'Player', inverse_of: :games_lost

    validate :existence

    private

    def existence
      errors.add(:winner, 'inexistent') unless player_exists?(winner)
      errors.add(:loser, 'inexistent') unless player_exists?(loser)
    end

    def player_exists?(player)
      player&.id && Player.find(player.id)
    end
  end
end
