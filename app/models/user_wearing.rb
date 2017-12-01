<<<<<<< HEAD
class UserWearing < ApplicationRecord

    def self.get_user_wearing_array(user_id)
        user_wearings = UserWearing.where(user_id: user_id).pluck(:clothe_id)
        return user_wearings 
    end

    def self.initialized_user_wearing(user_id)
        for num in 1..6 do
			user_wearing = UserWearing.new(user_id: user_id, tag_id: num ,clothe_id: num)
            user_wearing.save
		end
    end
end


=======
class UserWearing < ApplicationRecord

    def self.get_user_wearing_array (user_id)
        user_wearing = UserWearing.find_by(user_id: user_id)
        return [user_wearing.upper_clothes, user_wearing.lower_clothes, user_wearing.sox, user_wearing.front_hair, user_wearing.back_hair, user_wearing.face] 
    end
end


>>>>>>> origin/develop
