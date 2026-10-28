# Definition of done

What must be true for each model, one sentence per line, under its heading. Plain English,
no Ruby. Write the rules, not the columns: what can't be allowed, what can't be duplicated,
what must you be able to find? Every story in the README should be something these
sentences make true.

This file is yours. Your agent reads it and writes one test for each sentence, named with that
sentence. It doesn't write here. Whether every sentence got its test is yours to check.

## Studio
Every studio must have a name.
No two studios can have the same name.
Every movie a studio made can be found using that studio's id.

## Movie
Every movie must have a title.
Every movie must have a release year.
Every movie must have a rating.
Every movie must have a studio id.
A movie's studio id must match a studio that exists.
No two movies from the same studio can have the same title and release year.
A movie's release year must be between 1888 and next year.
A movie's rating must be one of G, PG, PG-13, R or NC-17.
A movie's studio can be found using the movie's studio id.
A movie's roles can be found using the movie's id, in the order they were added.
When all movies are listed, they come in order of release year, then title.
Every movie must have a director.
Every movie a director made can be found using the director's name.

## Actor
Every actor must have a name.
No two actors can have the same name.
Every role an actor has played can be found using that actor's id.

## Role
Every role must have a movie id.
A role's movie id must match a movie that exists.
Every role must have an actor id.
A role's actor id must match an actor that exists.
Every role must have a character name.
The same actor can't play the same character in the same movie twice.
A role's movie can be found using the role's movie id.
A role's actor can be found using the role's actor id.
