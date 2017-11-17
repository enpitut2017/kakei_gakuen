class DeleteManager < ActiveRecord::Migration[5.1]
  def change
      drop_table :managers
  end
end
