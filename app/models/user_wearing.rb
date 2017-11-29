class UserWearing < ApplicationRecord

    def self.get_user_wearing_array (user_id)
        user_wearing = UserWearing.find_by(user_id: user_id)
        return [user_wearing.upper_clothes, user_wearing.lower_clothes, user_wearing.sox, user_wearing.front_hair, user_wearing.back_hair, user_wearing.face] 
    end
end


