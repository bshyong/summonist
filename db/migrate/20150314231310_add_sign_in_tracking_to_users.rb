class AddSignInTrackingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :last_sign_in_ip, :string
  end
end
