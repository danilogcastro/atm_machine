require 'sinatra'
require 'pry-byebug'

require_relative './lib/models/atm_machine'
require_relative './lib/models/bills'
require_relative './lib/processors/fill'
require_relative './lib/serializers/atm'

ATM = AtmMachine.new

class App < Sinatra::Base
  get '/ping' do
    'PONG'
  end

  post '/fill' do
    payload = JSON.parse(request.body.read, symbolize_names: true)

    response = Processors::Fill.call(ATM, payload[:caixa])

    response.to_json
  end

  # post '/withdraw' do
  #   payload = JSON.parse(request.body.read, symbolize_names: true)

  #   response = Processors::Withdraw.call(ATM, payload[:saque])

  #   response.to_json
  # end
end