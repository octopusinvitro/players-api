# frozen_string_literal: true

require 'sinatra'
require 'sinatra/activerecord'

require_relative 'api/rank'

class APIapp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  before do
    content_type 'application/json'
  end

  get '/' do
    API::Rank.pluck(:name).to_json
  end
end
