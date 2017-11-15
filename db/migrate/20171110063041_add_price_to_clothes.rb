class AddPriceToClothes < ActiveRecord::Migration[5.1]
  def change
    add_column :clothes, :price, :integer
  end
end
