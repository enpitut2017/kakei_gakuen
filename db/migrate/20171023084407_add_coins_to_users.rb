class AddCoinsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :coin, :integer
  end
end
