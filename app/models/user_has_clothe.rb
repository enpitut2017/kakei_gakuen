class UserHasClothe < ApplicationRecord

    def self.user_has_clothe?(user_id, clothe_id)
        flag = false
<<<<<<< HEAD
        user_has_clothe = UserHasClothe.where(user_id: user_id, clothes_id:clothe_id)
        if ( ! user_has_clothe.empty?) then
=======
        user_has_clothe = UserHasClothe.where(user_id: user_id, clothe_id: clothe_id)
        if (user_has_clothe) then
>>>>>>> e0685573e92cfe6b59160ba6689c18303a1a7aec
            flag = true
        end
        return flag
    end

    def self.all_clothes_user_has_clothe_array(user_id)
        hash = {}
        clothes = Clothe.all
        clothes.each do |clothe|
            hash[clothe.id] = UserHasClothe::user_has_clothe?(user_id, clothe.id)
        end
        return hash
    end

    def self.initialized_user_has_clothe(user_id)
        for num in 1..12 do
			user_has_clothe = UserHasClothe.new(user_id: user_id, clothes_id: num);
			user_has_clothe.save
		end
    end
end
