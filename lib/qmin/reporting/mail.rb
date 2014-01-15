require 'mail'
require 'qmin/reporting/mail/mail_builder'

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

    end
  end
end