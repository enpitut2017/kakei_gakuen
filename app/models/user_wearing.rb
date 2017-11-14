class UserWearing < ApplicationRecord
    belongs_to :clothe
    belongs_to :clothes_tags_link
end
