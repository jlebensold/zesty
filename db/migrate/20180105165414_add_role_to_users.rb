# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
		 CREATE TYPE role AS ENUM ('admin', 'customer');
	 SQL
    add_column :users, :role, :role, index: true, null: false, default: "customer"
  end

  def down
    remove_column :users, :role

    execute <<-SQL
 		 DROP TYPE role;
    SQL
  end
end
