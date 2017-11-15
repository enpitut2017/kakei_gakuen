class Tag < ApplicationRecord
    has_many :clothes , through: :clothes_tags_links , dependent: :destroy
end
