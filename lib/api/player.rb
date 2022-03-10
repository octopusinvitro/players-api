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
    before_update :update_rank

    ALLOWED_FIELDS = %i[firstname lastname nationality birthdate].freeze
    FILTER_FIELDS = %i[nationality rank].freeze

    DAYS_IN_A_YEAR = 365.25
    MINIMUM_AGE = 16
    MINIMUM_GAMES = 3

    def self.filter(fields)
      ranking = all.order(score: :desc).pluck(:id)
      filtered = fields[:rank] ? filter_by_rank(fields) : filter_by_fields(fields)

      filtered.map { |player| player.jsonify(ranking.find_index(player.id) + 1) }
    end

    def self.filter_by_rank(fields)
      rank = fields.delete(:rank)
      Rank.find_by(name: rank.downcase).players.where(fields).order(score: :desc)
    end

    def self.filter_by_fields(fields)
      ranked = where.not(rank_id: Rank.unranked).where(fields).order(score: :desc)
      unranked = Rank.unranked.players.where(fields).order(score: :desc)
      ranked.to_a + unranked.to_a
    end

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

    def update_rank
      self.rank = can_update_rank? ? Rank.from_score(score) : self.rank
    end

    def can_update_rank?
      attribute_changed?(:score) && (games_won + games_lost).count >= MINIMUM_GAMES
    end
  end
end
