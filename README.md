[![build status](https://gitlab.com/octopusinvitro/players-api/badges/master/pipeline.svg)](https://gitlab.com/octopusinvitro/players-api/commits/master)
[![Coverage Status](https://coveralls.io/repos/github/octopusinvitro/players-api/badge.svg?branch=main)](https://coveralls.io/github/octopusinvitro/players-api?branch=main)
[![Maintainability](https://api.codeclimate.com/v1/badges/d8ccbdc9f2e519160aed/maintainability)](https://codeclimate.com/github/octopusinvitro/players-api/maintainability)
[![Depfu](https://badges.depfu.com/badges/0a4c5e533133dc8344ba5847bf0b437e/overview.svg)](https://depfu.com/github/octopusinvitro/players-api?project_id=34744)


# Readme

API for player management, with docs and a playground. See it at https://roleplayersapi.herokuapp.com/

![Page screenshot](screenshot.png)

**Diagram:**

```plaintext
game --->  | player  ---> | rank
---------------------------------
id         | id           | id
winner_id  | rank_id      | name
loser_id   | all fields   | description
```


## Project settings

* Optionally, turn your repo on in Coveralls (coverage status), codeclimate (maintainability), and depfu (dependency status).
* If you are using codeclimate, update the default branch name in the settings area.

**Folder structure:**

* `assets`: Dev assets
* `public`: Compiled assets
* `bin`: Executables
* `config`: Configuration files
* `db`: DB related files
* `lib`: Sources
* `spec`: Tests
* `views`: Webapp views


## How to use this project

This is a Ruby project. Tell your Ruby version manager to set your local Ruby version to the one specified in the `Gemfile`.

For example, if you are using [rbenv](https://cbednarski.com/articles/installing-ruby/):

1. Install the Ruby version: `rbenv install < VERSION >`
1. Install the `bundler` gem, which will allow you to install the rest of the dependencies listed in the `Gemfile` of this project.

  ```bash
  gem install bundler
  rbenv rehash
  ```


### Project setup

1. Install and setup `postgressql`:

  ```bash
  sudo apt update
  sudo apt install postgresql postgresql-contrib libpq-dev
  sudo -u postgres psql
      'postgres=#' \du
      'postgres=#' \l
      'postgres=#' \conninfo
      'postgres=#' \q
  ```
  Create a postgres user and database of the same name as your system user (find it with `whoami`). For example, if your system user is `ubuntu`:

  ```bash
  sudo -u postgres createuser --interactive
      'Enter name of role to add:' ubuntu
      'Shall the new role be a superuser? (y/n)' y
  sudo -u postgres createdb ubuntu
  ```

  Check the connection and create a password for them:
  ```bash
  sudo -u ubuntu psql
      'ubuntu=#' \conninfo
      'You are connected to database "ubuntu" as user "ubuntu"
       via socket in "/var/run/postgresql" at port "5432".'
      'ubuntu=#' ALTER ROLE ubuntu WITH PASSWORD 'new_password';
      'ubuntu=#' \q
  ```

1. Download Jasmine standalone ZIP file from [the releases page](https://github.com/jasmine/jasmine/releases) and copy the `lib` folder into `assets/js/`.

1. Install dependencies and setup databases:
  ```bash
  bundle install
  npm install
  RACK_ENV=development bundle exec rake db:setup db:migrate
  ```

1. Run the app and the tests to check that everything works (see sections below)

1. Syntax highlighting uses [prism.js by Lea Verou](https://prismjs.com/download.html).
  If changes are needed on the `prism.js` and `prism.scss` files in the `assets` folder, copy the URL at the top of the `prism.js` file and paste it in a browser. Add or remove options as needed and redownload the two files.

Optionally, install Heroku CLI tool, create an app and setup the project (check the [Heroku postgresql guide](https://devcenter.heroku.com/articles/heroku-postgresql) and the [Heroku connecting guide](https://devcenter.heroku.com/articles/connecting-heroku-postgres#connecting-in-ruby)):

```bash
sudo snap install heroku --classic
heroku login
heroku create roleplayersapi
heroku buildpacks:add --index 1 heroku/ruby
heroku buildpacks:add --index 2 heroku/nodejs
heroku addons:create heroku-postgresql
```

Then you can use it like this:

```bash
git push heroku main
heroku open
```

**Custom rake tasks:**

* `bundle exec rake assets`: Build assets (compile sass, join and minify JS and CSS files)
* `bundle exec rake watch`: Like `assets` plus rebuilds assets on change and serves JS tests

**Useful Heroku commands:**

* `heroku config`: List ENV vars
* `heroku logs --tail`: Check the logs
* `heroku run bash`: Run a remote shell in your local machine (`heroku run COMMAND` for any command)
* `heroku pg`: View db configuration
* `heroku pg:info`: View db information
* `heroku pg:psql`: Run a remote db prompt in your local machine
* `heroku pg:wait`: Check db status

**Other commands:**
* `sudo -u USERNAME psql`: Open a PostgreSQL session (useful commands: `\l`, `\c DATABASE`, `\dt`, `\q`)
* `bundle exec pry`: Open a Ruby prompt
* `binding.pry`: Drop it anywhere you want to insert a debug breakpoint


### To run the app

```bash
bundle exec rake assets
bundle exec puma
```

and go to http://localhost:9292/

Optionally you can also use `bundle exec rackup` or `RACK_ENV=development heroku local web` and port **5000**.


### To create a new migration

Check the [Sinatra activerecord docs](https://github.com/sinatra-activerecord/sinatra-activerecord). To create a table named `table_names` (`TableName` model):

```bash
bundle exec rake db:create_migration NAME=create_table_names
```

Edit the migration file to add fields and then run:

```bash
bundle exec rake db:migrate
```


## Frontend tests

```bash
bundle exec rake watch
```

and go to http://localhost:4000/tests/


## Backend tests


### To run all tests and rubocop

```bash
bundle exec rake
```


### To run a specific test file or unit test

```bash
bundle exec rspec path/to/test/file.rb
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```


### To run rubocop

```bash
bundle exec rubocop
```

## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License


## To do

* [ ] Make a better database diagram for the README
* [ ] try to make gulp-imagemin work?
* [ ] Make it a PWA ?
* [ ] Write the docs page. The documentation should contain:
    - relevant endpoints of the API
    - example requests of the endpoints
    - examples in several programming languages?
    - messages listed for different errors with their status codes
