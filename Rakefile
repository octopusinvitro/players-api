# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task(:default).clear
task default: %i[spec rubocop]

task(:watch) { sh('npm start') }
task(:assets) { sh('npm run assets') }
