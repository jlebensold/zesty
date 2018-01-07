# frozen_string_literal: true

class AddAttachmentAttachmentToOutputAssets < ActiveRecord::Migration[5.1]
  def self.up
    change_table :output_assets do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :output_assets, :attachment
  end
end
