class AddAttachmentAttachmentToInputAssets < ActiveRecord::Migration[5.1]
  def self.up
    change_table :input_assets do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :input_assets, :attachment
  end
end
