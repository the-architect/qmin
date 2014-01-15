module Qmin
  module Strategy
    class Inline
      # handle job in process
      def enqueue(worker_class, *args)
        worker_class.send :perform, *args
      end

      # call method directly
      def background_call(instance, method_name, *args)
        begin
          instance.send(::Qmin.method_name_for_instance(instance, method_name), *args)
        rescue => e
          ::Qmin::Qmin.current.report(e)
        end
      end
    end
  end
end