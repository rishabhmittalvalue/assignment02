require "test_helper"

class MovieTest < ActiveSupport::TestCase
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

  # A movie with every column filled in, not yet saved.
  def build_movie(studio)
    movie = Movie.new
    movie["title"] = "Batman Begins"
    movie["year_released"] = 2005
    movie["rated"] = "PG-13"
    movie["director"] = "Christopher Nolan"
    movie["studio_id"] = studio["id"]
    movie
  end

  test "Every movie must have a title." do
    warner = make_studio("Warner Bros.")

    movie = build_movie(warner)
    movie["title"] = nil
    assert_not movie.save, "a movie with no title was saved"

    movie = build_movie(warner)
    movie["title"] = ""
    assert_not movie.save, "a movie with a blank title was saved"

    assert_equal 0, Movie.count
  end

  test "Every movie must have a release year." do
    warner = make_studio("Warner Bros.")
    movie = build_movie(warner)
    movie["year_released"] = nil

    assert_not movie.save, "a movie with no release year was saved"
    assert_equal 0, Movie.count
  end

  test "Every movie must have a rating." do
    warner = make_studio("Warner Bros.")

    movie = build_movie(warner)
    movie["rated"] = nil
    assert_not movie.save, "a movie with no rating was saved"

    movie = build_movie(warner)
    movie["rated"] = ""
    assert_not movie.save, "a movie with a blank rating was saved"

    assert_equal 0, Movie.count
  end

  test "Every movie must have a studio id." do
    warner = make_studio("Warner Bros.")
    movie = build_movie(warner)
    movie["studio_id"] = nil

    assert_not movie.save, "a movie with no studio id was saved"
    assert_equal 0, Movie.count
  end

  test "A movie's studio id must match a studio that exists." do
    gone = make_studio("Gone Studios")
    gone_id = gone["id"]
    gone.destroy

    movie = build_movie(gone)
    movie["studio_id"] = gone_id
    assert_not movie.save, "a movie whose studio id matches no studio was saved"
    assert_equal 0, Movie.count
  end

  test "No two movies from the same studio can have the same title and release year." do
    warner = make_studio("Warner Bros.")
    paramount = make_studio("Paramount")
    make_movie("Batman Begins", 2005, "PG-13", warner)

    duplicate = build_movie(warner)
    assert_not duplicate.save, "a second Batman Begins (2005) from Warner Bros. was saved"
    assert_equal 1, Movie.where({ "studio_id" => warner["id"], "title" => "Batman Begins", "year_released" => 2005 }).count

    # The rule is only about the same title and year at the same studio.
    other_studio = build_movie(paramount)
    assert other_studio.save, "the same title and year from a different studio wasn't saved"

    other_year = build_movie(warner)
    other_year["year_released"] = 2006
    assert other_year.save, "the same title from the same studio in a different year wasn't saved"
  end

  test "A movie's release year must be between 1888 and next year." do
    warner = make_studio("Warner Bros.")
    next_year = Date.today.year + 1

    too_early = build_movie(warner)
    too_early["year_released"] = 1887
    assert_not too_early.save, "a movie released in 1887 was saved"

    too_late = build_movie(warner)
    too_late["year_released"] = next_year + 1
    assert_not too_late.save, "a movie released in #{next_year + 1} was saved"

    assert_equal 0, Movie.count

    first_year = build_movie(warner)
    first_year["title"] = "Roundhay Garden Scene"
    first_year["year_released"] = 1888
    assert first_year.save, "a movie released in 1888 wasn't saved"

    last_year = build_movie(warner)
    last_year["title"] = "Next Year's Movie"
    last_year["year_released"] = next_year
    assert last_year.save, "a movie released next year (#{next_year}) wasn't saved"
  end

  test "A movie's rating must be one of G, PG, PG-13, R or NC-17." do
    warner = make_studio("Warner Bros.")

    ["X", "PG13", "pg-13", "Unrated"].each do |rating|
      movie = build_movie(warner)
      movie["rated"] = rating
      assert_not movie.save, "a movie rated #{rating} was saved"
    end
    assert_equal 0, Movie.count

    ["G", "PG", "PG-13", "R", "NC-17"].each do |rating|
      movie = build_movie(warner)
      movie["title"] = "Rated #{rating}"
      movie["rated"] = rating
      assert movie.save, "a movie rated #{rating} wasn't saved"
    end
  end

  test "A movie's studio can be found using the movie's studio id." do
    make_studio("Paramount")
    warner = make_studio("Warner Bros.")
    movie = make_movie("Batman Begins", 2005, "PG-13", warner)

    studio = Studio.find_by({ "id" => movie["studio_id"] })

    assert_equal "Warner Bros.", studio["name"]
  end

  test "A movie's roles can be found using the movie's id, in the order they were added." do
    warner = make_studio("Warner Bros.")
    begins = make_movie("Batman Begins", 2005, "PG-13", warner)
    dark_knight = make_movie("The Dark Knight", 2008, "PG-13", warner)
    bale = make_actor("Christian Bale")
    caine = make_actor("Michael Caine")
    neeson = make_actor("Liam Neeson")
    ledger = make_actor("Heath Ledger")

    # Added in an order that is neither alphabetical by character nor by actor,
    # with another movie's role in between.
    first = make_role(begins, neeson, "Ra's Al Ghul")
    make_role(dark_knight, ledger, "Joker")
    second = make_role(begins, bale, "Bruce Wayne")
    third = make_role(begins, caine, "Alfred")

    found = Role.where({ "movie_id" => begins["id"] })

    assert_equal [first["id"], second["id"], third["id"]], found.map { |role| role["id"] }
  end

  test "When all movies are listed, they come in order of release year, then title." do
    warner = make_studio("Warner Bros.")
    # Created out of order: not by year, and the two 2008 movies not by title.
    make_movie("The Dark Knight Rises", 2012, "PG-13", warner)
    make_movie("The Dark Knight", 2008, "PG-13", warner)
    make_movie("Batman Begins", 2005, "PG-13", warner)
    make_movie("Arctic Knights", 2008, "PG", warner)

    titles = Movie.all.map { |movie| movie["title"] }

    assert_equal ["Batman Begins", "Arctic Knights", "The Dark Knight", "The Dark Knight Rises"], titles
  end

  test "Every movie must have a director." do
    warner = make_studio("Warner Bros.")

    movie = build_movie(warner)
    movie["director"] = nil
    assert_not movie.save, "a movie with no director was saved"

    movie = build_movie(warner)
    movie["director"] = ""
    assert_not movie.save, "a movie with a blank director was saved"

    assert_equal 0, Movie.count
  end

  test "Every movie a director made can be found using the director's name." do
    warner = make_studio("Warner Bros.")

    begins = build_movie(warner)
    begins["director"] = "Christopher Nolan"
    begins.save!

    other = build_movie(warner)
    other["title"] = "Batman"
    other["year_released"] = 1989
    other["director"] = "Tim Burton"
    other.save!

    dark_knight = build_movie(warner)
    dark_knight["title"] = "The Dark Knight"
    dark_knight["year_released"] = 2008
    dark_knight["director"] = "Christopher Nolan"
    dark_knight.save!

    found = Movie.where({ "director" => "Christopher Nolan" })

    assert_equal [begins["id"], dark_knight["id"]].sort, found.map { |movie| movie["id"] }.sort
  end
end
