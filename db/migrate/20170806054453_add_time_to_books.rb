class AddTimeToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :time, :datetime
  end
end
