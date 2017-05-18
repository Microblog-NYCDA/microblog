class ChangeUsersTableWithFriends < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.integer :friend_id
    end
  end
end
