class Book < ApplicationRecord
    validates :item ,presence: true
    validates :cost, numericality: true
end
