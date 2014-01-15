module Qmin
  module Resque
    class BackgroundCallJob
      def self.perform(*args)
        begin
          new(*args).perform
        rescue => e
          ::Qmin::Qmin.current.report(e)
        end
      end

      def initialize(klass, method_name, id)
        begin
          @klass = klass.is_a?(Class) ? klass : klass.constantize
          @method_name = method_name
          @id = id
        rescue => e
          ::Qmin::Qmin.current.report(e)
        end
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

