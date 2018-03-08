# frozen_string_literal: true

class AddJobNumberToClassificationJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :classification_jobs, :job_number, :integer, default: 1
  end
end
