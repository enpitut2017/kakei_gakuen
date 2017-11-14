class RemoveDetailsFromClothe < ActiveRecord::Migration[5.1]
  def change
    remove_column :clothes, :created_at, :timestamp
    remove_column :clothes, :updated_at, :timestamp
  end
end
