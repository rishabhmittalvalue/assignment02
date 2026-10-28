require "test_helper"

class ActorTest < ActiveSupport::TestCase
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

  def make_role(movie, actor, character_name)
    role = Role.new
    role["movie_id"] = movie["id"]
    role["actor_id"] = actor["id"]
    role["character_name"] = character_name
    role.save!
    role
  end

  test "Every actor must have a name." do
    actor = Actor.new
    assert_not actor.save, "an actor with no name was saved"

    actor = Actor.new
    actor["name"] = ""
    assert_not actor.save, "an actor with a blank name was saved"

    assert_equal 0, Actor.count
  end

  test "No two actors can have the same name." do
    make_actor("Michael Caine")

    duplicate = Actor.new
    duplicate["name"] = "Michael Caine"
    assert_not duplicate.save, "a second actor named Michael Caine was saved"

    assert_equal 1, Actor.where({ "name" => "Michael Caine" }).count
  end

  test "Every role an actor has played can be found using that actor's id." do
    warner = make_studio("Warner Bros.")
    begins = make_movie("Batman Begins", 2005, "PG-13", warner)
    dark_knight = make_movie("The Dark Knight", 2008, "PG-13", warner)
    caine = make_actor("Michael Caine")
    bale = make_actor("Christian Bale")

    alfred_begins = make_role(begins, caine, "Alfred")
    make_role(begins, bale, "Bruce Wayne")
    alfred_dark_knight = make_role(dark_knight, caine, "Alfred")

    found = Role.where({ "actor_id" => caine["id"] })

    assert_equal [alfred_begins["id"], alfred_dark_knight["id"]].sort, found.map { |role| role["id"] }.sort
  end
end
