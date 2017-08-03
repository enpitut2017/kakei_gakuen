class Book < ApplicationRecord
    belongs_to :user
    validates :item ,presence: true
    validates :cost, numericality: true

end
