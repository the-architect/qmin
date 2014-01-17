require 'qmin/qmin'

require 'qmin/core_ext/class'
require 'qmin/core_ext/string'

require 'qmin/strategy/inline'
require 'qmin/strategy/noop'

require 'qmin/reporting/inline'
require 'qmin/reporting/noop'

if defined? ::Resque
  require 'qmin/resque/background_call_job'
  require 'qmin/resque/base_job'
  require 'qmin/strategy/resque'
end

require 'qmin/reporting/mail' if defined? ::Mail
require 'qmin/reporting/honeybadger' if defined? ::Honeybadger


module Qmin

  protected

  def self.method_name_for_instance(instance, method_name)
    if instance.respond_to? :"#{method_name}_without_qmin"
      :"#{method_name}_without_qmin"
    else
      method_name
    end
  end
end
