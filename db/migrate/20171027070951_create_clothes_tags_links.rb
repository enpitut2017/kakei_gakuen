class CreateClothesTagsLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :clothes_tags_links do |t|
      t.integer :tag_id
      t.integer :clothes_id

      t.timestamps
    end
  end
end
