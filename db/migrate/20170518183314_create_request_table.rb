class CreateRequestTable < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.integer :user_id
      t.integer :requester_id
    end
  end
end
