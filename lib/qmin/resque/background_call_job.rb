module Qmin
  module Resque
    class BackgroundCallJob
      def self.perform(*args)
        new(*args).perform
      end

      def initialize(klass, method_name, id)
        @klass = klass.is_a?(Class) ? klass : klass.constantize
        @method_name = method_name
        @id = id
      end

      def perform
        begin
          instance = @klass.find(@id)
          instance.send(::Qmin.method_name_for_instance(instance, @method_name))
        rescue => e
          ::Qmin::Qmin.current.report(e)
        end
      end
    end
  end
end

