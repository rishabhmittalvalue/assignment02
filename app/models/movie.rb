class Movie < ApplicationRecord
  RATINGS = ["G", "PG", "PG-13", "R", "NC-17"]

  default_scope { order("year_released", "title") }

  validates :title, :year_released, :rated, :studio_id, presence: true
  validates :title, uniqueness: { scope: [:studio_id, :year_released] }
  validates :year_released, numericality: { only_integer: true, greater_than_or_equal_to: 1888, less_than_or_equal_to: ->(movie) { Date.today.year + 1 } }, allow_nil: true
  validates :rated, inclusion: { in: RATINGS }, allow_blank: true
  validate :studio_must_exist

  def studio_must_exist
    if self["studio_id"] != nil && Studio.find_by({ "id" => self["studio_id"] }) == nil
      errors.add(:studio_id, "must match a studio that exists")
    end
  end
end
