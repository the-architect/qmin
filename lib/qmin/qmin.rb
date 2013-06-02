module Qmin
  # Handles configuration and dispatches method calls to configured strategy
  class Qmin
    # configure default strategy
    def self.default_strategy=(strategy)
      @@default_strategy = strategy
    end

    def self.current
      @@current ||= new
    end

    def self.enqueue(worker_class, *args)
      current.enqueue worker_class, *args
    end

    def self.background_call(instance, method_name)
      current.background_call(instance, method_name)
    end

    def initialize(strategy = nil)
      begin
        @strategy = (strategy || @@default_strategy).new
      rescue NameError
        raise MustDefineStrategyError.new
      end
      @@current = self
    end

    def enqueue(worker_class, *args)
      @strategy.enqueue worker_class, *args
    end

    def background_call(instance, method_name)
      @strategy.background_call(instance, method_name)
    end
  end
end