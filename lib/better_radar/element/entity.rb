class BetterRadar::Element::Entity
  # implement in subclasses
  def assign_attributes(attributes, current_element, context)
    raise "TODO: implement in subclass"
  end

  def assign_content(content, current_element, context)
    raise "TODO: implement in subclass"
  end

  def assigned_variables
    variables = {}
    instance_variables.each do |var|
      variables[var] = instance_variable_get(var)
    end
    variables
  end
end
