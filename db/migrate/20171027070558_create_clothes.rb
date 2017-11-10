class CreateClothes < ActiveRecord::Migration[5.1]
  def change
    create_table :clothes do |t|
      t.string :file_name
      t.string :name

      t.timestamps
    end
  end
end
