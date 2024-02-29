module Services
  class BalanceCalculator
    def self.call(...)
      new(...).calculate
    end

    def initialize(bills)
      @bills = Adapters::Bills.adapt_from_strings(bills)
    end

    def calculate
      balance = 0

      @bills.each do |denomination, quantity|
        balance += (denomination.to_i * quantity)
      end

      balance
    end
  end
end