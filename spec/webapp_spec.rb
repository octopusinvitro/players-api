# frozen_string_literal: true

require 'webapp'

RSpec.describe Webapp do
  def app
    described_class.new
  end

  it 'loads "Try it!" by default' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Try it!')
  end

  it 'has a 404 page' do
    get '/inexistent'
    expect(last_response).to be_not_found
    expect(last_response.body).to include('Not found')
  end
end
