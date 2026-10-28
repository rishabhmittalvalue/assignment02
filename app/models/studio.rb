class Studio < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
