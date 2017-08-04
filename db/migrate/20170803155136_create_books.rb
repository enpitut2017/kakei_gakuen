class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :item
      t.integer :cost
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
