class CreateUserWearings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_wearings do |t|
      t.integer :user_id
      t.integer :tag_id
      t.integer :clothe_id

      t.timestamps
    end
  end
end
