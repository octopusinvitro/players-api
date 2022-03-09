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
end
