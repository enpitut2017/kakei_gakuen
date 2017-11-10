class Clothe < ApplicationRecord
    belongs_to :clothes_tags_link
    has_many :user_wearings , dependent :destroy
end
