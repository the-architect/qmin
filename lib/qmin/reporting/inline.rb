module Qmin
  module Reporting
    class Inline
      def report(exception)
        raise exception
      end
    end
  end
end