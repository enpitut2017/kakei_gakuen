class Book < ApplicationRecord
  belongs_to :user
  validates :item, presence: true
  validates :user, presence: true
  validates :cost, presence: true, numericality: true
  validates :time, presence: true
end
