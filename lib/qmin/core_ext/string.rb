unless !!defined?(ActiveSupport::Inflector)

  class String
    def underscore
      self.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr('-', '_').
        downcase
    end unless String.respond_to?(:underscore)

    # shamelessly stolen from resque
    def constantize
      names = self.split('::')
      names.shift if names.empty? || names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          args = Module.method(:const_defined?).arity != 1 ? [false] : []
          next candidate if constant.const_defined?(name, *args)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check it it's owned
          # directly before we reach Object or the end of ancestors.
          constant = constant.ancestors.inject do |const, ancestor|
            break const    if ancestor == Object
            break ancestor if ancestor.const_defined?(name, *args)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end unless String.respond_to?(:constantize)
  end

end

class String
  def to_queue_name
    gsub('::','').underscore
  end
end