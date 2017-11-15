class AddPriorityToTag < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :priority, :integer
  end
end
