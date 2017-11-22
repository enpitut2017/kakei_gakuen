class Clothe < ApplicationRecord
    mount_uploader :image, ImageUploader

    def self.get_user_wearing_tag_hash(user_id)
        tags = Tag.all
        keys_tags = Tag.pluck(:id)
        tags = Hash[keys_tags.collect.zip(tags)]

        user_wearing = UserWearing.find_by(user_id: user_id)
        clothes = Clothe.where(id: [user_wearing.upper_clothes, user_wearing.lower_clothes, user_wearing.sox, user_wearing.front_hair, user_wearing.back_hair, user_wearing.face])
        keys_clothes = Clothe.where(id: [user_wearing.upper_clothes, user_wearing.lower_clothes, user_wearing.sox, user_wearing.front_hair, user_wearing.back_hair, user_wearing.face]).pluck(:id)
        clothes = Hash[keys_clothes.collect.zip(clothes)]
        clothes_tags_links = ClothesTagsLink.where(clothes_id: keys_clothes)

        user_wearing_clothes = Hash.new
		clothes_tags_links.each do |clothes_tags_link|
			if user_wearing_clothes.has_key?(tags[clothes_tags_link.tag_id].tag) then
				user_wearing_clothes[tags[clothes_tags_link.tag_id].tag].push(clothes[clothes_tags_link.clothes_id])
			else
				user_wearing_clothes[tags[clothes_tags_link.tag_id].tag] = Array.new
				user_wearing_clothes[tags[clothes_tags_link.tag_id].tag].push(clothes[clothes_tags_link.clothes_id])
			end
        end
        
        return user_wearing_clothes
    end
end