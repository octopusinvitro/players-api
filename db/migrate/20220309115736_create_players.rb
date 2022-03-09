# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :nationality, null: false
      t.date :birthdate, null: false
      t.integer :score, default: 1200
      t.belongs_to :rank, foreign_key: true
      t.timestamps
    end

    add_index :players, %i[firstname lastname], unique: true
  end
end
