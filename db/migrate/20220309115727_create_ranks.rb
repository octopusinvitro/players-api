# frozen_string_literal: true

class CreateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :ranks do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description
      t.timestamps
    end
  end
end
