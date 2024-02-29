class AtmMachine
  attr_reader :available

  def initialize
    @available = false
    @bills = []
  end
end