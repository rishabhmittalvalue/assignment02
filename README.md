# KMDB, with models and tests

KMDB, the Kellogg Movie Database, again: the same stories and the same data, built this time
as a Rails app. The tables become migrations, what must be true becomes tests, and the Top
Cast report comes from models instead of a query.

You write the definition of done. Your AI agent writes the tests and the code. Your job in
between is to read what it wrote and judge it: does every sentence have a test, does each
test check what its sentence says, did the agent follow the rules in `AGENTS.md`. You commit
after each step, so your history shows the order you worked in.

## Getting started

1. Click **Use this template**, then **Create a new repository** in your own account. Choose
   **Private**, then add the graders (see "Private, with collaborators" below).
2. In your new repository: **Code**, then **Codespaces**, then **Create codespace on main**.
   The first start takes a few minutes.
3. Start your agent in the terminal (`claude`, `codex` or `agy`) and log in. The `agent-setup`
   repo's README has the details, including what to do when the sign-in page doesn't load.

## The stories

- As a guest, I want to see every movie with its title, year, rating and studio, so I can pick
  one to watch.
- As a guest, I want to see the movies a studio has made, so I can find more like the ones I
  liked.
- As a guest, I want to see each movie's top cast, with each actor's name and the character
  they play, so I know who is in it.
- As a guest, I want to see the movies an actor has been in, so I can follow an actor I like.

A guest is anyone using the site without logging in, so there is no table for guests.

## The wireframe

Two pages a guest might see. Anything in [brackets] is a link.

```
+--------------------------------------------------+
|  KMDB                                            |
+--------------------------------------------------+
|                                                  |
|  The Dark Knight                                 |
|  2008 · PG-13 · [Warner Bros.]                   |
|                                                  |
|  Top cast                                        |
|  [Christian Bale] ............ Bruce Wayne       |
|  [Heath Ledger] .............. Joker             |
|  [Aaron Eckhart] ............. Harvey Dent       |
|  [Michael Caine] ............. Alfred            |
|  [Maggie Gyllenhaal] ......... Rachel Dawes      |
|                                                  |
+--------------------------------------------------+

+--------------------------------------------------+
|  KMDB                                            |
+--------------------------------------------------+
|                                                  |
|  Michael Caine                                   |
|                                                  |
|  Movies                                          |
|  [Batman Begins] (2005) ...... Alfred            |
|  [The Dark Knight] (2008) .... Alfred            |
|                                                  |
+--------------------------------------------------+
```
*Note: wireframes are for planning; a later design step would decide what the UI actually looks like. This step in the process just ensures we can later support something like this.*

## The data

Christopher Nolan's Batman trilogy.

- **Batman Begins** was released in 2005, rated PG-13, and made by Warner Bros. Its top cast:
  - Christian Bale as Bruce Wayne
  - Michael Caine as Alfred
  - Liam Neeson as Ra's Al Ghul
  - Katie Holmes as Rachel Dawes
  - Gary Oldman as Commissioner Gordon
- **The Dark Knight** was released in 2008, rated PG-13, and made by Warner Bros. Its top cast:
  - Christian Bale as Bruce Wayne
  - Heath Ledger as Joker
  - Aaron Eckhart as Harvey Dent
  - Michael Caine as Alfred
  - Maggie Gyllenhaal as Rachel Dawes
- **The Dark Knight Rises** was released in 2012, rated PG-13, and made by Warner Bros. Its top
  cast:
  - Christian Bale as Bruce Wayne
  - Gary Oldman as Commissioner Gordon
  - Tom Hardy as Bane
  - Joseph Gordon-Levitt as John Blake
  - Anne Hathaway as Selina Kyle

## The report

The finished `report.rb` prints this, the same every time it runs. The spacing doesn't have
to match; the rows and their order do.

```
Movies
======

Batman Begins          2005           PG-13  Warner Bros.
The Dark Knight        2008           PG-13  Warner Bros.
The Dark Knight Rises  2012           PG-13  Warner Bros.

Top Cast
========

Batman Begins          Christian Bale        Bruce Wayne
Batman Begins          Michael Caine         Alfred
Batman Begins          Liam Neeson           Ra's Al Ghul
Batman Begins          Katie Holmes          Rachel Dawes
Batman Begins          Gary Oldman           Commissioner Gordon
The Dark Knight        Christian Bale        Bruce Wayne
The Dark Knight        Heath Ledger          Joker
The Dark Knight        Aaron Eckhart         Harvey Dent
The Dark Knight        Michael Caine         Alfred
The Dark Knight        Maggie Gyllenhaal     Rachel Dawes
The Dark Knight Rises  Christian Bale        Bruce Wayne
The Dark Knight Rises  Gary Oldman           Commissioner Gordon
The Dark Knight Rises  Tom Hardy             Bane
The Dark Knight Rises  Joseph Gordon-Levitt  John Blake
The Dark Knight Rises  Anne Hathaway         Selina Kyle
```

## The steps

Five steps, in order. **Every step ends the same way: run `bin/save-log`, then commit.**

To commit: **Source Control** (the branch icon on the left), type a message, **Commit**, then
**Sync Changes**. Write the message yourself, and make it say what this commit did ("Add the
four tables", not "update" or "step 1"), so the next person to read your history, or you next
week, can follow it. Your agent doesn't commit; you do.

### 1. The tables, by hand

Four models: `Studio`, `Movie`, `Actor` and `Role` (a role is one actor in one movie, playing
one character). Use these four names, whatever you called the tables before. These columns
are the starting point; add any you think the stories need:

| Model | Columns |
|---|---|
| `Studio` | `name` |
| `Movie` | `title`, `year_released`, `rated`, `studio_id` |
| `Actor` | `name` |
| `Role` | `movie_id`, `actor_id`, `character_name` |

Names are strings, years and the `_id` columns are integers. Keep the `_id` names as they are;
the lookups in the steps below use them.

For each model, in the terminal:

1. `bin/rails generate model Studio` (then `Movie`, `Actor`, `Role`). It makes an empty model
   in `app/models/` and a migration in `db/migrate/`.
2. In the migration, inside the `create_table` block, one line per column:
   `t.string "name"`, `t.integer "studio_id"`.

Then `bin/rails db:migrate`, and open `db/schema.rb`: Rails wrote it from your migrations, so
never edit it by hand. Type these yourself; your agent starts at step 3.

Run `bin/save-log`, then commit.

### 2. The definition of done

Open `DONE.md`. Under each model's heading, write what must be true, one sentence per line,
plain English, no Ruby. A sentence about a column ("A movie has a title") is allowed, but the
rules are the work: what can't be saved, what can't be duplicated, what you have to be able to
find. Go back to the stories: each one should be something your sentences make true.

Run `bin/save-log`, then commit, before your agent sees any of it.

### 3. Red: the tests, failing

Ask your agent for the tests, in your own words. Your prompt has to ask for four things: tests
from the sentences in `DONE.md`; run them and show them failing; follow `AGENTS.md`; stop
before writing any code in `app/models/`.

Then check its work. Open `DONE.md` and the test files side by side (drag one tab to the right
edge of the editor).

- Count: does every sentence have a test with its name?
- Read each test: does it check what its sentence says?

Your agent will tell you it's done. This is how you know. If a test is missing or checks the
wrong thing, send it back; if a sentence turns out to say less than you meant, fix the
sentence and ask for its test again.

Run `bin/rails test` yourself. Some tests may pass already, before any model code: the table
does the storing. Only the rules should be red.

Run `bin/save-log`, then commit.

### 4. Green: the models

Ask your agent to make the tests pass. Then read every file in `app/models/`: about one line
per rule is what to expect. Run `bin/rails test` yourself: all green.

Anything your agent did that `AGENTS.md` says not to, in any step, goes in `NOTES.md` under
"Where the agent broke a rule", with what you did about it.

Run `bin/save-log`, then commit.

### 5. The report

Ask your agent for `report.rb`, in your own words. It has to:

- delete every row first, so it can run more than once;
- create the studio, the three movies, the actors and their roles from "The data" above, with
  no typed-in ids: a row is found by what it is, `Studio.find_by({ "name" => "Warner Bros." })`,
  and its `["id"]` used from there;
- print the two reports in "The report" above, every studio name and actor name reached
  through an id lookup (`Studio.find_by({ "id" => movie["studio_id"] })`).

Run it twice with `bin/rails runner report.rb`: the same output both times.

Run `bin/save-log`, then commit. Then submit (below). Phase 2 opens when you do.

## Your agent's log

Every conversation you have with your agent in this folder is copied into `agent-log/`, one
file per conversation, and it goes into each commit with your work. **Graders read it**: your
prompts, the failing run before any model code, and what the agent did. It is how we see the
work between your commits, the way a chat link showed the chat before.

- It copies itself after each of your agent's turns. `bin/save-log` gathers anything still
  missing and prints what it found for each agent. Run it before every commit; it is safe to
  run any number of times.
- If it finds nothing for the agent you used, it says so and names that agent's own way to
  save a conversation; save it into `agent-log/` that way.
- Don't edit or delete anything in `agent-log/`. A log that shrinks or disappears between
  commits shows. Your agent is told never to touch it.
- It holds what your agent saw and did: your prompts, the files it read, the commands it ran
  and what they printed, and the email of the account you logged in with. Your repository is
  private, so only you and your graders can read it.

## How to submit

> [!IMPORTANT]
> We grade a fresh copy of your repository on GitHub. If it isn't committed and synced, it
> isn't there. If we can't open your repository, we can't grade it.

### Private, with collaborators

Your copy is private, so nobody can see it until you add them, the way you would on any real
project. When you click **Use this template**, choose **Private**. Then, on your new
repository's page on github.com:

1. **Settings** (the tab at the top), then **Collaborators** in the left bar. GitHub may ask
   for your password.
2. **Add people**. Type `bjblock`, pick it from the list, **Add to repository**.
3. Again for `mrjonesbot`, and again for `emplumb`.

All three show as pending until they accept, and that's fine. Already made your copy public?
**Settings**, scroll to the bottom, **Change visibility**, **Private**.

### Handing it in

1. Run `bin/save-log`, commit, then **Sync Changes**. On github.com, check that your commits
   are there, `agent-log/` included.
2. On Canvas, submit your repository's URL, like `https://github.com/YOUR-USERNAME/kmdb-models`.

Phase 2 arrives when you submit.

## Running things

From the top folder (where this README is):

| To | Run |
|---|---|
| Run a file | `bin/rails runner report.rb` |
| Run the tests | `bin/rails test` |
| Run new migrations | `bin/rails db:migrate` |
| See every table and its rows | `bin/rails runner data.rb` |
| Save your agent's log | `bin/save-log` |
| Start the database over | `bin/reset-db` |

`bin/reset-db` rebuilds the database from the migrations in `db/migrate/`. Every row is
deleted; your files stay as they are. Use it when the database is in a state you can't
explain, or a migration says a table already exists.

## When something breaks

Read the error from the top. The first line says what went wrong and where; the lines under
it are where Ruby was when it happened and can usually be ignored.

- **`table "movies" already exists`** (or any table): the database already has it. Check
  `db/migrate/` for two migrations that create the same table and remove the extra one, then
  run `bin/reset-db`.
- **`uninitialized constant Movie`**: there's no model file for it yet. Check
  `app/models/movie.rb`, and that the class name inside it matches.
- **`no such table: movies`**: the migration exists but hasn't run. Run `bin/rails db:migrate`.
- **`Migrations are pending`** when you run the tests: run `bin/rails db:migrate` first.
- **A column you forgot**: don't edit a migration you already ran. Add one with
  `bin/rails generate migration AddRatedToMovies`, a line like `add_column :movies, :rated, :string`
  in it, then `bin/rails db:migrate`.

## What is where

| Path | What it is |
|---|---|
| `db/migrate/` | Your four migrations, one per table |
| `db/schema.rb` | The tables as they are now, written by Rails from the migrations. Never edited by hand |
| `DONE.md` | Your definition of done: what must be true for each model, one sentence per line |
| `test/models/` | One test file per model; your agent writes a test for each sentence in `DONE.md` |
| `app/models/` | One class per table, and its rules |
| `report.rb` | The two reports, from the models |
| `NOTES.md` | Where the agent broke a rule, and what your tests did when a new rule arrived |
| `agent-log/` | Your agent's conversations, copied in for your graders |
| `AGENTS.md` | The rules for an AI agent working in this repo |
| `bin/save-log` | Copies your agent's conversations into `agent-log/` |
| `bin/reset-db` | Rebuilds the database from the migrations |
| `data.rb` | Prints every table and its rows |
