# frozen_string_literal: true

require_relative '../factories'

RSpec.describe API::Rank do
  let!(:rank) { described_class.create(name: described_class::UNRANKED) }

  describe '.unranked' do
    it 'returns unranked rank' do
      expect(described_class.unranked).to eq(rank)
    end
  end

  describe '#name' do
    it 'must be present' do
      expect(described_class.create.errors.messages[:name]).to include(/blank/)
    end

    it 'must be unique' do
      repeated = described_class.create(name: described_class::UNRANKED)
      expect(repeated.errors.messages[:name]).to include(/taken/)
    end
  end

  describe '#description' do
    it 'is optional' do
      expect(rank).to be_valid
    end
  end

  describe '#players' do
    it 'has many' do
      player1 = player(firstname: 'player1', rank:)
      player2 = player(firstname: 'player2', rank:)

      [player1, player2].map(&:save)

      expect(rank.players).to eq([player1, player2])
    end
  end
end
