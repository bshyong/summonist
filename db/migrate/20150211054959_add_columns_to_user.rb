class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, unique: true
    add_index :users, :username, unique: true
    add_column :users, :email, :string
    add_index :users, :email, unique: true
  end
end
