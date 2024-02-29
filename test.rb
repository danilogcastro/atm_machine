class BillsCalculator
  DENOMINATIONS = [100, 50, 20, 10]

  def self.call(value)
    new.calculate(value)
  end

  def calculate(value)
    DENOMINATIONS.each do |denomination|
      num_bills = value / denomination
  
      value -= num_bills * denomination
      
      bills[denomination.to_s] += num_bills
  
      break if value == 0
    end

    Adapter.call(bills)
  end

  def bills
    @bills ||= {
      '10' => 0,
      '20' => 0,
      '50' => 0,
      '100' => 0
    }
  end
end

class Adapter
  def self.call(hash)
    {
      notasDez: hash['10'],
      notasVinte: hash['20'],
      notasCinquenta: hash['50'],
      notasCem: hash['100']
    }
  end
end

p BillsCalculator.call(80)