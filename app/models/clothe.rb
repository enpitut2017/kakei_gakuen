class Clothe < ApplicationRecord
    mount_uploader :image, ImageUploader
    belongs_to :clothes_tags_link
    has_many :user_wearings , dependent: :destroy
end
