class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :item
      t.integer :cost
      t.integer :user_id

      t.timestamps
    end
    add_index :Books, :user_id
  end
end
