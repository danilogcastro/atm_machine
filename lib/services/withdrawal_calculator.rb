module Services
  class WithdrawalCalculator
    DENOMINATIONS = [100, 50, 20, 10]

    def self.call(...)
      new(...).calculate
    end

    def initialize(available_bills:, value:)
      @available_bills = Adapters::Bills.adapt_from_strings(available_bills)
      @value           = value
    end

    # CALCULA QUANTAS NOTAS PRECISAM SER RETIRADAS 
    # E RETORNA A NOVA COMPOSIÇÃO DO CAIXA
    def calculate
      DENOMINATIONS.each do |denomination|
        num_bills = @value / denomination

        num_bills.times do
          break if @available_bills[denomination.to_s] == 0

          @value -= denomination

          @available_bills[denomination.to_s] -= 1
        end

        break if @value == 0
      end

      Adapters::Bills.adapt_from_numbers(@available_bills)
    end
  end
end