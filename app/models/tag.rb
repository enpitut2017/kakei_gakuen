class Tag < ApplicationRecord
    mount_uploader :image, ImageUploader
    
    def self.get_tag_key_hash
        tags = Tag.all
        keys_tags = Tag.pluck(:tag)
        tags = Hash[keys_tags.collect.zip(tags)]
        
        return tags
    end

end
