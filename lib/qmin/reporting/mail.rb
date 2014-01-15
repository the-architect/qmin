require 'mail'

module Qmin
  module Reporting
    class Mail

      class << self
        def setup_delivery(delivery_method, delivery_options = {})
          @delivery_method  = delivery_method
          @delivery_options = delivery_options
        end

        def delivery_method
          @delivery_method
        end

        def delivery_options
          @delivery_options
        end

        def setup_mail(to, from)
          @mail_to    = to
          @mail_from  = from
        end

        def mail_to
          @mail_to
        end

        def mail_from
          @mail_from
        end
      end

      def report(exception)
        deliver(mail(exception))
      end

      private

      def mail(exception)
        MailBuilder.new(exception, self.class.mail_to, self.class.mail_from).build
      end

      def deliver(mail)
        if self.class.delivery_method && self.class.delivery_options
          mail.delivery_method(self.class.delivery_method, self.class.delivery_options)
        end
        
        mail.deliver
      end


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
end