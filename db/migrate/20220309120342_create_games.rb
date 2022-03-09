# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :winner, foreign_key: { to_table: 'players' }
      t.references :loser, foreign_key: { to_table: 'players' }
      t.timestamps
    end
  end
end
