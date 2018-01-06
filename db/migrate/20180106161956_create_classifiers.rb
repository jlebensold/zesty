# frozen_string_literal: true

class CreateClassifiers < ActiveRecord::Migration[5.1]
  def change
    create_table :classifiers do |t|
      t.string :name
      t.json :meta
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
