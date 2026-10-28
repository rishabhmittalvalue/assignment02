class Role < ApplicationRecord
  default_scope { order("id") }

  validates :movie_id, :actor_id, :character_name, presence: true
  validates :character_name, uniqueness: { scope: [:movie_id, :actor_id] }
  validate :movie_must_exist
  validate :actor_must_exist

  def movie_must_exist
    if self["movie_id"] != nil && Movie.find_by({ "id" => self["movie_id"] }) == nil
      errors.add(:movie_id, "must match a movie that exists")
    end
  end

  def actor_must_exist
    if self["actor_id"] != nil && Actor.find_by({ "id" => self["actor_id"] }) == nil
      errors.add(:actor_id, "must match an actor that exists")
    end
  end
end
