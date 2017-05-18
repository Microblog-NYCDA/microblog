class AddUserIdToBlogs < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.integer :user_id
    end
  end
end
