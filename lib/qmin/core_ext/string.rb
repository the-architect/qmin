unless String.instance_methods.include?(:snake_case)

  class String
    def snake_case
      self.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        downcase
    end
  end

end

unless String.instance_methods.include?(:constantize)

  class String
    def constantize
      Kernel.const_get(self)
    end
  end

end


unless String.instance_methods.include?(:to_queue_name)

  class String
    def to_queue_name
      gsub('::','').snake_case
    end
  end

end