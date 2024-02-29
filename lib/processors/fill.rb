module Processors
  class Fill
    def self.call(...)
      new(...).execute
    end

    def initialize(atm, payload)
      @atm     = atm
      @payload = payload
    end

    def execute
      # mudar o estado do caixa se necessário
      # inserir as notas se o caixa estiver fora de uso
    end
  end
end