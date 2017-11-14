class RenameUpperColthetToUserWearing < ActiveRecord::Migration[5.1]
  def change
      rename_column :user_wearings, :upper_colthes, :upper_clothes
  end
end
