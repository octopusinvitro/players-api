[![build status](https://gitlab.com/octopusinvitro/players-api/badges/master/pipeline.svg)](https://gitlab.com/octopusinvitro/players-api/commits/master)
[![Coverage Status](https://coveralls.io/repos/github/octopusinvitro/players-api/badge.svg?branch=main)](https://coveralls.io/github/octopusinvitro/players-api?branch=main)
[![Maintainability](https://api.codeclimate.com/v1/badges/d8ccbdc9f2e519160aed/maintainability)](https://codeclimate.com/github/octopusinvitro/players-api/maintainability)
[![Depfu](https://badges.depfu.com/badges/0a4c5e533133dc8344ba5847bf0b437e/overview.svg)](https://depfu.com/github/octopusinvitro/players-api?project_id=34744)


# Readme

API for player management, with docs and a playground.


## Project settings

* Optionally, turn your repo on in Coveralls (coverage status), codeclimate (maintainability), and depfu (dependency status).
* If you are using codeclimate, update the default branch name in the settings area.


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


* `bin `: Executables
* `lib `: Sources
* `spec`: Tests

Install dependencies:

```bash
bundle install
```


### To run the app

Make sure that the `bin/app` file has execution permissions:

```bash
chmod +x bin/app
```

Then just type:

```bash
bin/app
```

If this doesn't work you can always do:

```bash
bundle exec ruby bin/app
```


## Tests


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
