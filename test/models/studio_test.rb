require "test_helper"

class StudioTest < ActiveSupport::TestCase
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
    movie["studio_id"] = studio["id"]
    movie.save!
    movie
  end

  test "Every studio must have a name." do
    studio = Studio.new
    assert_not studio.save, "a studio with no name was saved"

    studio = Studio.new
    studio["name"] = ""
    assert_not studio.save, "a studio with a blank name was saved"

    assert_equal 0, Studio.count
  end

  test "No two studios can have the same name." do
    make_studio("Warner Bros.")

    duplicate = Studio.new
    duplicate["name"] = "Warner Bros."
    assert_not duplicate.save, "a second studio named Warner Bros. was saved"

    assert_equal 1, Studio.where({ "name" => "Warner Bros." }).count
  end

  test "Every movie a studio made can be found using that studio's id." do
    warner = make_studio("Warner Bros.")
    paramount = make_studio("Paramount")
    begins = make_movie("Batman Begins", 2005, "PG-13", warner)
    make_movie("Interstellar", 2014, "PG-13", paramount)
    dark_knight = make_movie("The Dark Knight", 2008, "PG-13", warner)

    found = Movie.where({ "studio_id" => warner["id"] })

    assert_equal [begins["id"], dark_knight["id"]].sort, found.map { |movie| movie["id"] }.sort
  end
end
