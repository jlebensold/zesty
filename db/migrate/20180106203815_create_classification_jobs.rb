# frozen_string_literal: true

class CreateClassificationJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :classification_jobs do |t|
      t.references :classifier
      t.string :status
      t.timestamps null: false
    end
  end
end
