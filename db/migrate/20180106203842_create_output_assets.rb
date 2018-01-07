# frozen_string_literal: true

class CreateOutputAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :output_assets do |t|
      t.string :label, null: false, default: ""
      t.references :classifier, null: false
      t.references :classification_job, null: false
      t.timestamps null: false
    end
  end
end
