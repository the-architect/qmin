module Qmin
  module Strategy
    # Strategy to handle background calls and queuing of worker jobs with Resque
    # This will only be available if the Resque constant is defined when you require 'qmin'
    # If somehow this is not working for you, add:
    #    require 'qmin/resque/background_call_job'
    #    require 'qmin/resque/base_job'
    #    require 'qmin/strategy/resque'
    # where needed
    #
    # Methods that are annotated with "background_method" will be handled by
    # the generic Qmin::Resque::BackgroundCallJob worker.
    # It will automatically create a queue name based on the class and method it is working on.
    #
    # So for example:
    #
    # * Jobs::Profile#update_facebook_friends is annotated to be a background_method
    # * 'qmin_resque_background_call_job_jobs_profile_update_facebook_friends' will be the queue name
    #
    class Resque
      # Just passes
      def enqueue(worker_class, *args)
        ::Resque.enqueue worker_class, *args
      end

      # @param klass
      # Queue name is based on worker class and method name
      # By default Qmin::Resque::BackgroundCallJob will handle jobs
      def background_call(instance, method_name)
        ::Resque.enqueue_to(queue_name(instance.class.name, method_name), self.class.job_class, instance.class.name, method_name, instance.id)
      end

      protected

      def queue_name(klass_name, method_name)
        [
          self.class.job_class.name.to_queue_name,
          klass_name.to_queue_name,
          method_name
        ].join('_')
      end

      def self.job_class
        ::Qmin::Resque::BackgroundCallJob
      end
    end
  end
end