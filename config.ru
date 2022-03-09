# frozen_string_literal: true

require './lib/apiapp'
require './lib/webapp'

run Rack::URLMap.new(
  '/' => Webapp,
  '/api/v1' => APIapp
)
