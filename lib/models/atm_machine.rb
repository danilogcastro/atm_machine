class AtmMachine
  attr_reader :bills
  attr_accessor :available

  def initialize(available: false, bills: Bills.new)
    @available = available
    @bills     = bills
  end

  def fill(new_bills)
    new_bills.each do |type, value|
      bills[type.to_sym] += value
    end
  end

  def update_bills(new_bills)
    @bills = Bills.new(**new_bills)
  end

  def empty?
    Services::BalanceCalculator.call(@bills).zero?
  end
end