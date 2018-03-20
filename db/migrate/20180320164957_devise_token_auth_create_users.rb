# frozen_string_literal: true

class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :provider, :string, default: "email", null: false
    add_column :users, :allow_password_change, :boolean, default: false
    add_column :users, :tokens, :json
  end
end
