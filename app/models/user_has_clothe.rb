class UserHasClothe < ApplicationRecord
    
    def self.user_has_clothe?(user_id, clothe_id)
        flag = false
        user_has_clothe = UserHasClothe.where(user_id: user_id, clothes_id: clothe_id)
        if ( ! user_has_clothe.empty?) then
            flag = true
        end
        return flag
    end

    def self.all_clothes_user_has_clothe_array(user_id)
        hash = {}
        clothes = Clothe.all
        user_has_clothes_array = UserHasClothe.where(user_id: user_id).pluck(:clothes_id)
        clothes.each do |clothe|
            hash[clothe.id] = user_has_clothes_array.include?(clothe.id) 
        end
        return hash
    end

    def self.initialized_user_has_clothe(user_id)
        user_has_clothe = []
        for num in 1..12 do
			user_has_clothe.push(UserHasClothe.new(user_id: user_id, clothes_id: num))
        end
        UserHasClothe.import user_has_clothe
    end
end
