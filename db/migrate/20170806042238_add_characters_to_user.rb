class AddCharactersToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :exp, :integer
    add_column :users, :level, :integer
  end
end
