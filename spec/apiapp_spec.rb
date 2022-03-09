# frozen_string_literal: true

require 'apiapp'

require_relative 'factories'

RSpec.describe APIapp do
  let(:app) { described_class.new }

  describe 'show home' do
    it 'smoke test' do
      rank(name: 'gold').save
      rank(name: 'bronze').save

      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq(%w[gold bronze].to_json)
    end
  end
end
