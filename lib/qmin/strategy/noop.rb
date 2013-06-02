module Qmin
  module Strategy
    class Noop
      def enqueue(*args)
      end

      def background_call(*args)
      end
    end
  end
end