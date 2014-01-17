module Qmin
  module Reporting
    class Honeybadger
      def report(exception)
        ::Honeybadger.notify_or_ignore(exception)
      end
    end
  end
end