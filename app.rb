require 'sinatra'
require 'pry-byebug'

require_relative './lib/models/atm_machine'
require_relative './lib/models/bills'
require_relative './lib/processors/fill'
require_relative './lib/processors/withdraw'
require_relative './lib/serializers/atm'
require_relative './lib/services/withdrawal_calculator'
require_relative './lib/services/balance_calculator'
require_relative './lib/adapters/bills'

ATM = AtmMachine.new

class App < Sinatra::Base
  get '/ping' do
    'PONG'
  end

  post '/fill' do
    payload = JSON.parse(request.body.read, symbolize_names: true)

    response, errors = Processors::Fill.call(ATM, payload[:caixa])

    Serializers::Atm.call(atm: response, errors: errors)
  end

  post '/withdraw' do
    payload = JSON.parse(request.body.read, symbolize_names: true)

    response, errors = Processors::Withdraw.call(ATM, payload[:saque])

    Serializers::Atm.call(atm: response, errors: errors)
  end
end