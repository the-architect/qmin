unless !!defined?(ActiveSupport::Inflector)

  class String
    def underscore
      self.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        downcase
    end

    def constantize
      Kernel.const_get(self)
    end

    def to_queue_name
      gsub('::','').underscore
    end
  end

end