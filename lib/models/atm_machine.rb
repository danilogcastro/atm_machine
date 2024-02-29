class AtmMachine
  attr_reader :bills
  attr_accessor :available, :last_withdrawal

  def initialize(available: false, bills: Bills.new)
    @available       = available
    @bills           = bills
    @last_withdrawal = {}
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
    @bills.to_h.empty?
  end
end