class AddPriorityToClothes < ActiveRecord::Migration[5.1]
  def change
    add_column :clothes, :priority, :integer
  end
end
