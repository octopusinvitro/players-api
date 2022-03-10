# frozen_string_literal: true

require_relative '../factories'

RSpec.describe API::Game do
  let(:winner) { player(firstname: 'Winner') }
  let(:loser) { player(firstname: 'Loser') }
  let(:game) { described_class.new(winner:, loser:) }

  before { [winner, loser, game].map(&:save) }

  describe '#winner' do
    it 'is linked with game' do
      winner.save
      expect(game.winner.firstname).to eq(winner.firstname)
    end

    it 'is linked with games won' do
      expect(winner.games_won).to eq([game])
    end

    it 'can not be null' do
      game = described_class.create(
        winner: nil,
        loser: player(firstname: 'unsaved2')
      )
      expect(game.errors.messages[:winner]).to include(/inexistent/)
    end

    it 'must exist in database' do
      game = described_class.create(
        winner: player(firstname: 'unsaved1'),
        loser: player(firstname: 'unsaved2')
      )
      expect(game.errors.messages[:winner]).to include(/inexistent/)
    end
  end

  describe('#loser') do
    it 'is linked with game' do
      expect(game.loser.firstname).to eq(loser.firstname)
    end

    it 'is linked with games lost' do
      game.save
      expect(loser.games_lost).to eq([game])
    end

    it 'must exist' do
      game = described_class.create(
        winner: player(firstname: 'unsaved1'),
        loser: player(firstname: 'unsaved2')
      )
      expect(game.errors.messages[:loser]).to include(/inexistent/)
    end
  end

  describe 'scores recalculation' do
    it 'gives high-score winner 10% of loser score' do
      winner = player(firstname: 'Serena', score: 1000)
      loser = player(firstname: 'Venus', score: 900)
      [winner, loser].map(&:save)

      described_class.create(winner:, loser:)

      expect([winner, loser].map(&:score)).to eq([1090, 810])
    end

    it 'gives low-score winner 10% of loser score' do
      winner = player(firstname: 'Venus', score: 700)
      loser = player(firstname: 'Serena', score: 1200)
      [winner, loser].map(&:save)

      described_class.create(winner:, loser:)

      expect([winner, loser].map(&:score)).to eq([820, 1080])
    end
  end

  describe '#jsonify' do
    it 'returns game attributes' do
      expected = {
        winner: {
          firstname: winner.firstname,
          lastname: winner.lastname,
          score: winner.score
        },
        loser: {
          firstname: loser.firstname,
          lastname: loser.lastname,
          score: loser.score
        }
      }
      expect(game.jsonify).to include(expected)
    end
  end
end
