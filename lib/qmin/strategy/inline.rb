module Qmin
  module Strategy
    class Inline
      # handle job in process
      def enqueue(worker_class, *args)
        worker_class.send :perform, *args
      end

      # call method directly
      def background_call(instance, method_name)
        instance.send(::Qmin.method_name_for_instance(instance, method_name))
      end
    end
  end
end