# frozen_string_literal: true

require_relative '../factories'

RSpec.describe API::Player do
  it 'creates a player' do
    expect(player).to be_valid
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
end
