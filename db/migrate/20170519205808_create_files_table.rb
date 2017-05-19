class CreateFilesTable < ActiveRecord::Migration[5.1]
  def change
      create_table :files do |t|
          t.integer :user_id
          t.binary :file
      end
  end
end
