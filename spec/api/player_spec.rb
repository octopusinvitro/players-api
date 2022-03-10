# frozen_string_literal: true

require_relative '../factories'

RSpec.describe API::Player do
  it 'creates a player' do
    expect(player).to be_valid
  end

  describe('.filter') do
    before { rank.save }

    it 'filters unranked and sorts by score desc' do
      player(nationality: 'French', score: 8000).save
      player(firstname: 'lo unranked', score: 1200).save
      player(firstname: 'hi unranked', score: 1300).save

      filtered = described_class.filter(nationality: 'nationality')

      expect(filtered.map { |player| player[:score] }).to eq([1300, 1200])
    end

    it 'filters ranked and sorts by score desc' do
      gold = rank(name: 'gold')
      bronze = rank(name: 'bronze')
      player(nationality: 'French', score: 8000, rank: gold).save
      player(firstname: 'lo ranked', score: 2000, rank: bronze).save
      player(firstname: 'hi ranked', score: 6000, rank: gold).save

      filtered = described_class.filter(nationality: 'nationality')

      expect(filtered.map { |player| player[:score] }).to eq([6000, 2000])
    end

    it 'filters and sorts unranked below ranked' do
      player(firstname: 'unranked', score: 1200).save
      player(firstname: 'anotheru', score: 2000).save
      player(firstname: 'lo ranked', score: 1300, rank: rank(name: 'bronze')).save
      player(firstname: 'hi ranked', score: 6000, rank: rank(name: 'gold')).save

      filtered = described_class.filter(nationality: 'nationality')

      expect(filtered.map { |player| player[:score] }).to eq([6000, 1300, 2000, 1200])
    end

    it 'filters by rank name' do
      bronze = rank(name: 'bronze')
      player(firstname: 'rank 3', score: 4000, rank: bronze).save
      player(firstname: 'rank 1', score: 1200).save
      player(firstname: 'rank 2', score: 2000, rank: bronze).save
      player(firstname: 'rank 4', score: 6000, rank: bronze).save

      filtered = described_class.filter(rank: 'Bronze')

      expect(filtered.map { |player| player[:score] }).to eq([6000, 4000, 2000])
    end
  end

  describe '#name' do
    it 'must be present' do
      expect(described_class.create.errors.messages[:firstname]).to include(/blank/)
      expect(described_class.create.errors.messages[:lastname]).to include(/blank/)
    end

    it 'must have a unique full name' do
      player.save

      repeated = player
      repeated.save

      expect(repeated.errors.messages[:fullname]).to include(/taken/)
    end

    it 'can repeat first name' do
      player.save
      expect(player(firstname: 'DifferentName')).to be_valid
    end

    it 'can repeat last name' do
      player.save
      expect(player(lastname: 'DifferentSurname')).to be_valid
    end
  end

  describe '#nationality' do
    it 'must be present' do
      expect(described_class.create.errors.messages[:birthdate]).to include(/blank/)
    end
  end

  describe '#birthdate' do
    it 'must be present' do
      expect(described_class.create.errors.messages[:birthdate]).to include(/blank/)
    end

    it 'must be over minimum age' do
      too_young = player(birthdate: Date.today - (described_class::MINIMUM_AGE - 1).years)
      too_young.save
      expect(too_young.errors.messages[:birthdate]).to include(/below minimum/)
    end
  end

  describe '#score' do
    it 'defaults to a value on creation' do
      expect(player.score).to_not be_nil
    end
  end

  describe '#rank' do
    it 'stores unranked on creation' do
      rank(name: API::Rank::UNRANKED).save
      expect(player.rank.name).to eq(API::Rank::UNRANKED)
    end
  end

  describe '#jsonify' do
    let(:example) do
      rank.save
      player(birthdate: Date.today - 42.years)
    end

    def expected
      {
        firstname: 'firstname',
        lastname: 'lastname',
        age: 42,
        nationality: 'nationality',
        rank: API::Rank::UNRANKED.capitalize,
        score: 1200
      }
    end

    it 'returns specific player attributes' do
      expect(example.jsonify(123)).to include({ position: 123 }.merge(expected))
    end

    it 'has no position by default' do
      expect(example.jsonify).to include(expected)
    end
  end
end
