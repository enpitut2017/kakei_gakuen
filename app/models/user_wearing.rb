class UserWearing < ApplicationRecord

    def self.get_user_wearing_array(user_id)
        user_wearings = UserWearing.where(user_id: user_id).pluck(:clothe_id)
        return user_wearings 
    end

    def self.get_user_wearing_tag_hash(user_id)
        user_wearings = UserWearing.where(user_id: user_id)
        user_wearings_hash = {}
        user_wearings.each do |user_wearing|
            user_wearings_hash[user_wearing.tag_id] = user_wearing
        end

        return user_wearings_hash
    end

    def self.initialized_user_wearing(user_id)
        initial_clothes=[1,2,4,5,6,7,8,9,11,12]
        clothes_tag_links = ClothesTagsLink.get_clothes_tags_links_hash_from_clothes(initial_clothes)
        user_wearing = []
        clothes_tag_links.each do |key, value|
			user_wearing.push(UserWearing.new(user_id: user_id, tag_id: key ,clothe_id: value))
        end
        UserWearing.import user_wearing

        if Rails.env == 'production' then
            clothes = Clothe.where(id: initial_clothes).order(:priority)
            image_path = []
            clothes.each do |clothe|
                image_path.push('https://'+clothe.image.to_s)
            end

            postdata = {"url[]" => image_path, "id" => user_id}
            url = "https://kakeigakuen-staging.xyz/api/image/"
            c = HTTPClient.new
            c.connect_timeout = 100
            c.send_timeout    = 100
            c.receive_timeout = 100

            puts c.post_content(url, postdata)
        end 
    end
end


