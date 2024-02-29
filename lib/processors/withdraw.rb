module Processors
  class Withdraw
    def self.call(...)
      new(...).execute
    end

    def initialize(atm, payload)
      @atm     = atm
      @payload = payload
      @errors  = []
    end

    def execute
      check_if_available
      check_balance

      if @errors.empty?
        bills = Services::WithdrawalCalculator.call(available_bills: @atm.bills, value: @payload[:valor])
        @atm.update_bills(bills)
      end

      [@atm, @errors]
    end

    def check_balance
      @errors << 'valor-indisponível' if @atm.available && insufficient_balance?
    end

    def check_if_available
      @errors << 'caixa-indisponível' unless @atm.available
    end

    def insufficient_balance?
      balance = Services::BalanceCalculator.call(@atm.bills)

      balance < @payload[:valor]
    end
  end
end