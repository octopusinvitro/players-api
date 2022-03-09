# frozen_string_literal: true

require_relative '../lib/api/rank'

unranked = API::Rank::UNRANKED
ranks = [
  [unranked, '(The player has played less than 3 games)'],
  ['bronze', '0 – 2999 points'],
  ['silver', '3000 – 4999 points'],
  ['gold', '5000 – 9999 points'],
  ['legend', '10000 points – no limit']
]

ranks.each do |name, description|
  API::Rank.create(name:, description:)
end
