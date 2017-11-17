class RenameUpperColthetToUserWearing < ActiveRecord::Migration[5.1]
  def change
      rename_column :user_wearings, :upper_clothes, :upper_clothes
  end
end
