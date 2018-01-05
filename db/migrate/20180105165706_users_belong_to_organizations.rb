# frozen_string_literal: true

class UsersBelongToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :organization, index: true
  end
end
