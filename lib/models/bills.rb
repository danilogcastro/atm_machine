class Bills < OpenStruct
  def initialize
    super(notasDez: 0, notasVinte: 0, notasCinquenta: 0, notasCem: 0)
  end
end