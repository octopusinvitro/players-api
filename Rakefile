# frozen_string_literal: true

require 'sinatra/activerecord/rake'

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RSpec::Core::RakeTask.new(:spec)
  RuboCop::RakeTask.new

  task(:default).clear
  task default: %i[spec rubocop]
end

task(:watch) { sh('npm start') }
task(:assets) { sh('npm run assets') }

namespace :db do
  task(:load_config) { require './lib/apiapp' }
end
