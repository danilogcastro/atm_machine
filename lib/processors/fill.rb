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
      if @atm.available
        @errors << 'caixa-em-uso'
      else
        @atm.available = @payload[:caixaDisponivel]
        @atm.fill(@payload[:notas])
      end

      Serializers::Atm.call(atm: @atm, errors: @errors)
    end
  end
end