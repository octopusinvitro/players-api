# frozen_string_literal: true

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RSpec::Core::RakeTask.new(:spec)
  RuboCop::RakeTask.new

  task(:default).clear
  task default: %i[spec rubocop]
end

task(:watch) { sh('node_modules/gulp/bin/gulp.js') }
task(:assets) { sh('node_modules/gulp/bin/gulp.js assets') }
