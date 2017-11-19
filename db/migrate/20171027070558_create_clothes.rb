class CreateClothes < ActiveRecord::Migration[5.1]
  def change
    create_table :clothes do |t|
      t.string :file_name
      t.string :name
      t.integer :price
      t.string :image
      t.integer :priority

      t.timestamps
    end
  end
end
