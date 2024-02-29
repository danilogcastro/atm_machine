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
      check_last_withdrawal
      check_balance

      if @errors.empty?
        bills = Services::WithdrawalCalculator.call(available_bills: @atm.bills, value: @payload[:valor])
        @atm.update_bills(bills)
        @atm.last_withdrawal = { time: @payload[:horario], value: @payload[:valor] }
      end

      [@atm, @errors]
    rescue
      @errors << 'caixa-inexistente'

      [{}, @errors]
    end

    private

    def check_balance
      @errors << 'valor-indisponível' if @atm.available && insufficient_balance?
    end

    def check_last_withdrawal
      @errors << 'saque-duplicado' if @atm.available && forbidden_withdrawal?
    end

    def check_if_available
      @errors << 'caixa-indisponível' unless @atm.available
    end

    def forbidden_withdrawal?
      @atm.last_withdrawal[:value] == @payload[:valor] && less_than_ten_minutes_ago?
    end

    def less_than_ten_minutes_ago?
      last = Time.new(@atm.last_withdrawal[:time])
      current = Time.new(@payload[:horario])

      # diferença entre último saque e o atual menor que 600 segundos ou 10 minutos
      current - last < 600
    end

    def insufficient_balance?
      balance = Services::BalanceCalculator.call(@atm.bills)

      balance < @payload[:valor]
    end
  end
end