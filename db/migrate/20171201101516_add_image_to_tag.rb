class AddImageToTag < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :image, :string
  end
end
