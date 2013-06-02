# Extends class with #background_method(method_name)
# The annotated method will be handled by Qmin and it's current strategy
class Class
  # @param method_name
  # Decorates a method to be handled by Qmin's #background_call method
  # Calls to the method will then be handled by the configured Qmin::Strategy#background_call method
  # The original method is still available through "<method_name>_without_qmin"
  def background_method(method_name)
    return if respond_to?("#{method_name}_without_qmin") || !!method_name.to_s.match(/_without_qmin$/)

    alias_method "#{method_name}_without_qmin", method_name

    define_method method_name do
      ::Qmin::Qmin.background_call(self, method_name)
    end
  end

  # @param *method_names
  # annotates all methods as background_methods
  # see #background_method for more information
  def background_methods(*method_names)
    method_names.map(&:to_s).each{|method_name| background_method method_name }
  end
end
