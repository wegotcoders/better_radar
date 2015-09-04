class BetterRadar::Element::Entity
  # implement in subclasses
  def assign_attributes(attributes, current_element, context)
    raise "TODO: implement in subclass"
  end

  def assign_content(content, current_element, context)
    raise "TODO: implement in subclass"
  end

  def assign_variable variable_name, value, options = {}
    object = options[:object] || self
    raise "Method Name #{variable_name} Not Found on #{object}" unless object.respond_to?("#{variable_name}".to_sym)
    unless options[:append]
      object.instance_variable_set("@#{variable_name}", value)
    else
      unless instance_variable_get("@#{variable_name}").nil?
        object.instance_variable_set("@#{variable_name}", value)
      else
        object.instance_variable_get("@#{variable_name}") << value
      end
    end
  end

  def assigned_variables
    variables = {}
    instance_variables.each do |var|
      variables[var] = instance_variable_get(var)
    end
    variables
  end
end
