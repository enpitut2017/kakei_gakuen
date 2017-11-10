class ClothesTagsLink < ApplicationRecord
    belongs_to :tag
    belongs_to :clothe
end
