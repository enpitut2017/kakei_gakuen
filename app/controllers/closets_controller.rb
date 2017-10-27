class ClosetsController < ApplicationController
    def edit
        @user_clothes = UserWearing.find_by(user_id: current_user.id)
        user_has_clothes = UserHasClothe.find_by(user_id: current_user.id)
        tmp_clothes = array()
        user_has_clothes.each do |cloth|
            
        end
        clothes_tags_link = ClothesTagsLink.all
        tags = tags.all
    end

    def update
    end
end
