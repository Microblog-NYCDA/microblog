class CreateProfileInfoTable < ActiveRecord::Migration[5.1]
  def change
      create_table :profiles do |t|
          t.string :name
          t.string :username
          t.string :city
          t.string :age
      end
  end
end
