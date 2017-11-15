class RemovePriorityFromTags < ActiveRecord::Migration[5.1]
  def change
    remove_column :tags, :priority, :integer
  end
end
