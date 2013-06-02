module Qmin
  module Resque
    # Defines a handy base class for Resque workers for the following pattern:
    # * Find an instance of a model by id
    # * call a method on the instance
    #
    class BaseJob
      MustRespondToFindMethodError = Class.new(StandardError) do
        @message = 'Model must respond to #find method!'
      end

      ImplementationMissing = Class.new(StandardError)

      # delegate perform to job instance
      def self.perform(*args)
        new(*args).perform
      end

      def self.model(model)
        if model.respond_to? :find
          @@model = model
        else
          raise MustRespondToFindMethodError
        end
      end

      def initialize(id, *args)
        @id = id
      end

      def perform
        raise ImplementationMissing.new("Please implement #perform instance method for job: #{self.class.name}")
      end

      def instance
        @instance ||= find_instance(@id)
      end

      def find_instance(id)
        model.find(id)
      end

      def model
        @@model
      end

      def self.queue
        # automatic queue naming
        @queue ||= self.name.to_queue_name
      end
    end
  end
end