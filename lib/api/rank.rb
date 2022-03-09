# frozen_string_literal: true

require 'sinatra/activerecord'

module API
  class Rank < ActiveRecord::Base
    has_many :players
    validates :name, presence: true, uniqueness: true

    UNRANKED = 'unranked'

    def self.unranked
      find_by(name: UNRANKED)
    end
  end
end
