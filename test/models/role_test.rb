require "test_helper"

class RoleTest < ActiveSupport::TestCase
  def make_studio(name)
    studio = Studio.new
    studio["name"] = name
    studio.save!
    studio
  end

  def make_movie(title, year_released, rated, studio)
    movie = Movie.new
    movie["title"] = title
    movie["year_released"] = year_released
    movie["rated"] = rated
    movie["director"] = "Christopher Nolan"
    movie["studio_id"] = studio["id"]
    movie.save!
    movie
  end

  def make_actor(name)
    actor = Actor.new
    actor["name"] = name
    actor.save!
    actor
  end

  # A role with every column filled in, not yet saved.
  def build_role(movie, actor)
    role = Role.new
    role["movie_id"] = movie["id"]
    role["actor_id"] = actor["id"]
    role["character_name"] = "Alfred"
    role
  end

  def setup
    @warner = make_studio("Warner Bros.")
    @begins = make_movie("Batman Begins", 2005, "PG-13", @warner)
    @caine = make_actor("Michael Caine")
  end

  test "Every role must have a movie id." do
    role = build_role(@begins, @caine)
    role["movie_id"] = nil

    assert_not role.save, "a role with no movie id was saved"
    assert_equal 0, Role.count
  end

  test "A role's movie id must match a movie that exists." do
    gone = make_movie("Gone Movie", 2000, "R", @warner)
    gone_id = gone["id"]
    gone.destroy

    role = build_role(@begins, @caine)
    role["movie_id"] = gone_id
    assert_not role.save, "a role whose movie id matches no movie was saved"
    assert_equal 0, Role.count
  end

  test "Every role must have an actor id." do
    role = build_role(@begins, @caine)
    role["actor_id"] = nil

    assert_not role.save, "a role with no actor id was saved"
    assert_equal 0, Role.count
  end

  test "A role's actor id must match an actor that exists." do
    gone = make_actor("Gone Actor")
    gone_id = gone["id"]
    gone.destroy

    role = build_role(@begins, @caine)
    role["actor_id"] = gone_id
    assert_not role.save, "a role whose actor id matches no actor was saved"
    assert_equal 0, Role.count
  end

  test "Every role must have a character name." do
    role = build_role(@begins, @caine)
    role["character_name"] = nil
    assert_not role.save, "a role with no character name was saved"

    role = build_role(@begins, @caine)
    role["character_name"] = ""
    assert_not role.save, "a role with a blank character name was saved"

    assert_equal 0, Role.count
  end

  test "The same actor can't play the same character in the same movie twice." do
    dark_knight = make_movie("The Dark Knight", 2008, "PG-13", @warner)
    build_role(@begins, @caine).save!

    duplicate = build_role(@begins, @caine)
    assert_not duplicate.save, "Michael Caine as Alfred in Batman Begins was saved twice"
    assert_equal 1, Role.where({ "movie_id" => @begins["id"], "actor_id" => @caine["id"], "character_name" => "Alfred" }).count

    # The same actor and character in a different movie is a different role.
    sequel = build_role(dark_knight, @caine)
    assert sequel.save, "Michael Caine as Alfred in The Dark Knight wasn't saved"
  end

  test "A role's movie can be found using the role's movie id." do
    make_movie("The Dark Knight", 2008, "PG-13", @warner)
    role = build_role(@begins, @caine)
    role.save!

    movie = Movie.find_by({ "id" => role["movie_id"] })

    assert_equal "Batman Begins", movie["title"]
  end

  test "A role's actor can be found using the role's actor id." do
    make_actor("Christian Bale")
    role = build_role(@begins, @caine)
    role.save!

    actor = Actor.find_by({ "id" => role["actor_id"] })

    assert_equal "Michael Caine", actor["name"]
  end
end
