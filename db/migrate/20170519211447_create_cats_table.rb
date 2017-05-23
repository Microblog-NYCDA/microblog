class CreateCatsTable < ActiveRecord::Migration[5.1]
  def change
  	create_table :cats do |t|
  		t.integer :user_id
  		t.binary :file
  	end
  end
end
