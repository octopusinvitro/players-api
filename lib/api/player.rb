# frozen_string_literal: true

require 'sinatra/activerecord'

require_relative 'rank'

module API
  class Player < ActiveRecord::Base
    belongs_to :rank
    has_many :games_won, class_name: 'Game', inverse_of: :winner, foreign_key: 'winner_id'
    has_many :games_lost, class_name: 'Game', inverse_of: :loser, foreign_key: 'loser_id'

    validates_presence_of :firstname, :lastname, :nationality, :birthdate
    validate :unique_fullname
    validate :minimum_age

    after_initialize :default_rank

    ALLOWED_FIELDS = %i[firstname lastname nationality birthdate].freeze
    DAYS_IN_A_YEAR = 365.25
    MINIMUM_AGE = 16

    def jsonify(position = nil)
      {
        position:,
        firstname:,
        lastname:,
        age:,
        nationality:,
        rank: rank.name.capitalize,
        score:
      }.compact
    end

    private

    def unique_fullname
      errors.add(:fullname, 'Full name already taken.') if Player.find_by(firstname:, lastname:)
    end

    def minimum_age
      errors.add(:birthdate, "below minimum age (#{MINIMUM_AGE})") if age < MINIMUM_AGE
    end

    def age
      return 0 unless birthdate

      difference_in_days = Date.today - birthdate
      (difference_in_days / DAYS_IN_A_YEAR).round
    end

    def default_rank
      self.rank ||= Rank.unranked
    end
  end
end
