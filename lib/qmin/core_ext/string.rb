class String

  def underscore
    self.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr('-', '_').
      downcase
  end unless String.respond_to?(:underscore)

  # copied from resque
  def constantize
    names = self.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      args = Module.method(:const_get).arity != 1 ? [false] : []

      if constant.const_defined?(name, *args)
        constant = constant.const_get(name)
      else
        constant = constant.const_missing(name)
      end
    end
    constant
  end unless String.respond_to?(:constantize)


  def to_queue_name
    gsub('::','').underscore
  end

end