# frozen_string_literal: true

require 'sinatra/activerecord'

module API
  class Rank < ActiveRecord::Base
    has_many :players
    validates :name, presence: true, uniqueness: true

    UNRANKED = 'unranked'
    FROM_SCORE_TABLE = {
      'bronze' => (0..2999),
      'silver' => (3000..4999),
      'gold' => (5000..9999)
    }.freeze

    def self.unranked
      find_by(name: UNRANKED)
    end

    def self.from_score(score)
      return unranked if score.negative?

      FROM_SCORE_TABLE.each do |name, points_range|
        return find_by(name:) if points_range.include?(score)
      end

      find_by(name: 'legend')
    end
  end
end
