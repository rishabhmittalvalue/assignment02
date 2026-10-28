# Start over, so the report is the same every time it runs.
Role.delete_all
Movie.delete_all
Actor.delete_all
Studio.delete_all

# The studio.
studio = Studio.new
studio["name"] = "Warner Bros."
studio.save!

warner = Studio.find_by({ "name" => "Warner Bros." })

# The movies, each with its top cast in billing order.
movies = [
  {
    "title" => "Batman Begins",
    "year_released" => 2005,
    "rated" => "PG-13",
    "cast" => [
      ["Christian Bale", "Bruce Wayne"],
      ["Michael Caine", "Alfred"],
      ["Liam Neeson", "Ra's Al Ghul"],
      ["Katie Holmes", "Rachel Dawes"],
      ["Gary Oldman", "Commissioner Gordon"]
    ]
  },
  {
    "title" => "The Dark Knight",
    "year_released" => 2008,
    "rated" => "PG-13",
    "cast" => [
      ["Christian Bale", "Bruce Wayne"],
      ["Heath Ledger", "Joker"],
      ["Aaron Eckhart", "Harvey Dent"],
      ["Michael Caine", "Alfred"],
      ["Maggie Gyllenhaal", "Rachel Dawes"]
    ]
  },
  {
    "title" => "The Dark Knight Rises",
    "year_released" => 2012,
    "rated" => "PG-13",
    "cast" => [
      ["Christian Bale", "Bruce Wayne"],
      ["Gary Oldman", "Commissioner Gordon"],
      ["Tom Hardy", "Bane"],
      ["Joseph Gordon-Levitt", "John Blake"],
      ["Anne Hathaway", "Selina Kyle"]
    ]
  }
]

for data in movies
  movie = Movie.new
  movie["title"] = data["title"]
  movie["year_released"] = data["year_released"]
  movie["rated"] = data["rated"]
  movie["studio_id"] = warner["id"]
  movie.save!

  movie = Movie.find_by({ "title" => data["title"], "studio_id" => warner["id"] })

  for actor_name, character_name in data["cast"]
    # Create each actor only once; reuse them in later movies.
    actor = Actor.find_by({ "name" => actor_name })
    if actor == nil
      actor = Actor.new
      actor["name"] = actor_name
      actor.save!
    end

    role = Role.new
    role["movie_id"] = movie["id"]
    role["actor_id"] = actor["id"]
    role["character_name"] = character_name
    role.save!
  end
end

# The Movies report. Movies come in order of release year, then title.
puts "Movies"
puts "======"
puts ""

for movie in Movie.all
  studio = Studio.find_by({ "id" => movie["studio_id"] })
  puts "#{movie["title"].ljust(23)}#{movie["year_released"].to_s.ljust(15)}#{movie["rated"].ljust(7)}#{studio["name"]}"
end

# The Top Cast report. Each movie's roles come in the order they were added.
puts ""
puts "Top Cast"
puts "========"
puts ""

for movie in Movie.all
  for role in Role.where({ "movie_id" => movie["id"] })
    actor = Actor.find_by({ "id" => role["actor_id"] })
    puts "#{movie["title"].ljust(23)}#{actor["name"].ljust(22)}#{role["character_name"]}"
  end
end
