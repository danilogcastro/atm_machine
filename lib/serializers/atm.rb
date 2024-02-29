module Serializers
  class Atm

    def self.call(...)
      new(...).serialize
    end

    def initialize(atm:, errors: [])
      @atm    = atm
      @errors = errors
    end

    def serialize
      {
        caixa: @atm.empty? ? {} : atm_info ,
        erros: @errors
      }.to_json
    end

    private
    
    def atm_info
      {
        caixaDisponivel: @atm.available,
        notas: @atm.bills.to_h
      }
    end
  end
end