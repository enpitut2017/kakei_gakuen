class AddImageToClothes < ActiveRecord::Migration[5.1]
  def change
    add_column :clothes, :image, :string
  end
end
