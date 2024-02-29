module Processors
  class Fill
    def self.call(...)
      new(...).execute
    end

    def initialize(atm, payload)
      @atm     = atm
      @payload = payload
      @errors  = []
    end

    def execute
      check_if_available

      if @errors.empty?
        @atm.available = @payload[:caixaDisponivel]
        @atm.fill(@payload[:notas])
      end

      [@atm, @errors]
    end

    def check_if_available
      @errors << 'caixa-em-uso' if @atm.available
    end
  end
end