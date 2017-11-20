class CreateUserWearings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_wearings do |t|
      t.integer :user_id
      t.integer :upper_clothes
      t.integer :lower_clothes
      t.integer :sox
      t.integer :front_hair
      t.integer :back_hair
      t.integer :face

      t.timestamps
    end
  end
end
