class ClothesTagsLink < ApplicationRecord
    
    def self.get_clothes_tags_links_hash_from_tag(tag_id)
        clothes_tags_links = ClothesTagsLink.where(tag_id: tag_id)
		clothes_tag_links_hash = {}
		clothes_tags_links.each{|clothes_tags_link|
			clothes_tag_links_hash[clothes_tags_link.tag_id] = clothes_tags_link.clothes_id
        }
        return clothes_tag_links_hash
    end

    def self.get_clothes_tags_links_hash_from_clothes(clothe_id)
        clothes_tags_links = ClothesTagsLink.where(clothes_id: clothe_id)
		clothes_tag_links_hash = {}
		clothes_tags_links.each{|clothes_tags_link|
			clothes_tag_links_hash[clothes_tags_link.tag_id] = clothes_tags_link.clothes_id
        }
        return clothes_tag_links_hash
    end
end
