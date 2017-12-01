class Tag < ApplicationRecord
    mount_uploader :image, ImageUploader
end
