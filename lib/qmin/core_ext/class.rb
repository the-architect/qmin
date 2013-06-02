# Extends class with #background(method_name)
# The annotated method will be handled by Qmin and it's current strategy
class Class
  # @param *method_names
  # Define one or many methods that you want to be handled by Qmin's #background_call method.
  # Calls to these methods will be handled by the configured Qmin::Strategy#background_call method
  # The original methods are still available through "<method_name>_without_qmin"
  def background(*method_names)
    method_names.each do |method_name|
      define_qmin_background_method method_name.to_s
    end
  end

  def define_qmin_background_method(method_name)
    return if respond_to?("#{method_name}_without_qmin") || !!method_name.match(/_without_qmin$/)

    alias_method "#{method_name}_without_qmin", method_name.to_sym

    define_method method_name do
      ::Qmin::Qmin.background_call(self, method_name.to_sym)
    end
  end
end
