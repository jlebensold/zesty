class CreateInputAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :input_assets do |t|
      t.string :label,              null: false, default: ""
      t.references :classifier, null: false
      t.timestamps null: false
    end
  end
end
