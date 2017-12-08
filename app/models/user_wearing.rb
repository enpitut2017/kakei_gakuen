class UserWearing < ApplicationRecord

    def self.get_user_wearing_array(user_id)
        user_wearings = UserWearing.where(user_id: user_id).pluck(:clothe_id)
        return user_wearings 
    end

    def self.initialized_user_wearing(user_id)
        initial_clothes=[1,2,4,5,6,7,8,9,11,12]
        clothes_tag_links = ClothesTagsLink.get_clothes_tags_links_hash_from_clothes(initial_clothes)
        user_wearing = []
        clothes_tag_links.each do |key, value|
			user_wearing.push(UserWearing.new(user_id: user_id, tag_id: key ,clothe_id: value))
        end
        UserWearing.import user_wearing
    end
end


