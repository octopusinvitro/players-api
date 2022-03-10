# frozen_string_literal: true

require_relative '../factories'

RSpec.describe API::Rank do
  let!(:rank) { described_class.create(name: described_class::UNRANKED) }

  describe '.unranked' do
    it 'returns unranked rank' do
      expect(described_class.unranked).to eq(rank)
    end
  end

  describe '.from_score' do
    it 'is bronze if between 0 and 2999' do
      described_class.create(name: 'bronze')
      score = rand(3000)
      expect(described_class.from_score(score).name).to eq('bronze')
    end

    it 'is silver if between 3000 and 4999' do
      described_class.create(name: 'silver')
      score = rand(3000..5000)
      expect(described_class.from_score(score).name).to eq('silver')
    end

    it 'is gold if between 5000 and 9999' do
      described_class.create(name: 'gold')
      score = rand(5000..10_000)
      expect(described_class.from_score(score).name).to eq('gold')
    end

    it 'is legend if 10000 points and beyond' do
      described_class.create(name: 'legend')
      score = rand(10_000..10_100)
      expect(described_class.from_score(score).name).to eq('legend')
    end

    it 'is unranked if negative' do
      described_class.create(name: 'legend')
      score = -1
      expect(described_class.from_score(score).name).to eq(described_class::UNRANKED)
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
