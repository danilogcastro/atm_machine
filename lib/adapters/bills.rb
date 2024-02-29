module Adapters
  class Bills
    def self.adapt_from_numbers(hash)
      {
        notasDez: hash['10'],
        notasVinte: hash['20'],
        notasCinquenta: hash['50'],
        notasCem: hash['100']
      }
    end

    def self.adapt_from_strings(hash)
      {
        '10' => hash['notasDez'],
        '20' => hash['notasVinte'],
        '50' => hash['notasCinquenta'],
        '100' => hash['notasCem']
      }
    end
  end
end