class CreateCommentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :content
    end
  end
end
