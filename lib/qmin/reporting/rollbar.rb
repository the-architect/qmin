module Qmin
  module Reporting
    class Rollbar
      def report(exception)
        ::Rollbar.report_exception(exception)
      end
    end
  end
end



