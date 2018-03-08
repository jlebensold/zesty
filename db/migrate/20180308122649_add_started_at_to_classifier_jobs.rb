# frozen_string_literal: true

class AddStartedAtToClassifierJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :classification_jobs, :started_at, :datetime, default: nil
  end
end
