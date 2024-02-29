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
        caixa: {
          caixaDisponivel: @atm.available,
          notas: @atm.bills.to_h
        },
        erros: @errors
      }
    end
  end
end