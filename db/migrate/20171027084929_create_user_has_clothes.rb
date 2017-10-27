class CreateUserHasClothes < ActiveRecord::Migration[5.1]
  def change
    create_table :user_has_clothes do |t|
      t.integer :user_id
      t.integer :clothes_id

      t.timestamps
    end
  end
end
