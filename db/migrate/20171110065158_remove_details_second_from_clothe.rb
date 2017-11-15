class RemoveDetailsSecondFromClothe < ActiveRecord::Migration[5.1]
  def change
    remove_column :clothes, :created_at, :date
    remove_column :clothes, :updated_at, :date
  end
end
