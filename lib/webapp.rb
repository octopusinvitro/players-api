# frozen_string_literal: true

require 'sinatra/base'

class Webapp < Sinatra::Base
  set :views, "#{settings.root}/../views"

  get '/' do
    erb :index
  end

  not_found do
    erb :notfound
  end
end
