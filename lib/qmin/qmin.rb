module Qmin
  # Handles configuration and dispatches method calls to configured strategy
  class Qmin

    class << self
      def default_reporter=(reporter)
        @default_reporter = reporter
      end

      def default_reporter
        @default_reporter ||= Reporting::Inline
      end

      # configure default strategy
      def default_strategy=(strategy)
        @default_strategy = strategy
        @current = nil
      end

      def default_strategy
        @default_strategy || Strategy::Inline
      end

      def current
        @current ||= new
      end

      def enqueue(worker_class, *args)
        current.enqueue worker_class, *args
      end

      def background_call(instance, method_name)
        current.background_call(instance, method_name)
      end
    end

    def initialize
      @strategy = self.class.default_strategy.new
      @reporter = self.class.default_reporter.new
    end

    def enqueue(worker_class, *args)
      @strategy.enqueue worker_class, *args
    end

    def background_call(instance, method_name)
      @strategy.background_call(instance, method_name)
    end
  end
end