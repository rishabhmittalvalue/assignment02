# AGENTS.md

Instructions for an AI agent working in this repo.

This is a Rails app for KMDB, a small movie database. Run everything from the top folder (where
README.md is).

- Run a Ruby file with `bin/rails runner <path>`. Run the tests with `bin/rails test`. Tests
  go in `test/models/<model>_test.rb`.
- The person's rules are in `DONE.md`, one sentence per line under each model's heading.
  Write one test for each sentence in `test/models/<model>_test.rb`, named with that
  sentence. Every sentence gets a test. Never edit `DONE.md`; if a sentence is unclear or
  can't be tested, say so instead.
- Red first. Write the tests, run them and show them failing, then write the code, then run
  the tests again and show them passing. When asked only for tests, stop after the failing
  run and don't touch `app/models/`.
- No `has_many`, `belongs_to` or other associations. Look related rows up with `where` or
  `find_by`, for example `Role.where({ "movie_id" => movie["id"] })` or
  `Studio.find_by({ "id" => movie["studio_id"] })`. A lookup used more than once may become a
  method on the model.
- Read and set columns hash-style: `movie["title"]` and `movie["title"] = "Batman Begins"`,
  not `movie.title`.
- Never hard-code an id. Find a row by what it is (`Studio.find_by({ "name" => "Warner Bros." })`)
  and use its `["id"]`.
- Change the database's structure only with a migration: `bin/rails generate model` or
  `bin/rails generate migration`, then `bin/rails db:migrate`. Never edit `db/schema.rb`;
  Rails writes it.
- `bin/reset-db` rebuilds the database from the migrations and deletes every row. Ask before
  running it.
- Never run `git`. The person commits their own work.
- Never read, edit, move or delete anything in `agent-log/`. It is the record of this
  conversation, kept for the person's graders.
- Explain what you changed in plain English, file by file.
