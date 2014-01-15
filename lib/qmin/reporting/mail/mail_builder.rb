module Qmin
  module Reporting
    class MailBuilder
      def initialize(exception, mail_to, mail_from)
        @exception, @mail_to, @mail_from = exception, mail_to, mail_from
      end

      attr_reader :exception, :mail_to, :mail_from

      def build
        mail = ::Mail.new

        mail.to       mail_to
        mail.from     mail_from
        mail.subject  subject
        mail.body     clean_backtrace.join("\n")

        mail
      end

      private

      def subject
        "[ERROR] Qmin Report: #{exception.message}"
      end

      # copied from exception_notification gem
      # http://github.com/smartinez87/exception_notification
      def clean_backtrace
        if defined?(Rails) && Rails.respond_to?(:backtrace_cleaner)
          Rails.backtrace_cleaner.send(:filter, exception.backtrace)
        else
          exception.backtrace
        end
      end
    end
  end
end