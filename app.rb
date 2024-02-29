require 'sinatra'
require 'pry-byebug'

require_relative './lib/models/atm_machine'
require_relative './lib/processors/fill'

class App < Sinatra::Base
  ATM = AtmMachine.new

  get '/ping' do
    'PONG'
  end

  post '/fill' do
    payload = JSON.parse(request.body.read, symbolize_names: true)

    response = Processors::Fill.call(ATM, payload[:caixa])

    response.to_json
  end
end