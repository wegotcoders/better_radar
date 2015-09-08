class BetterRadar::Element::Entity < BetterRadar::Element::Base
  # implement in subclasses
  def assign_attributes(attributes, current_element, context)
    raise "TODO: implement in subclass"
  end

  def assign_content(content, current_element, context)
    raise "TODO: implement in subclass"
  end

  def assign_variable variable_name, value, options = {}
    object = options[:object] || self
    unless object.class == Hash
      unless object.respond_to?("#{variable_name}".to_sym)
        raise "Method Name #{variable_name} Not Found on #{object}"
      end
      unless options[:append]
        object.instance_variable_set("@#{variable_name}", value)
      else
        if object.instance_variable_get("@#{variable_name}").nil?
          object.instance_variable_set("@#{variable_name}", value)
        else
          object.instance_variable_get("@#{variable_name}") << value
        end
      end
    else
      if options[:append]
        if object["#{variable_name}".to_sym].nil?
          object["#{variable_name}".to_sym] = "#{value} "
        else
          object["#{variable_name}".to_sym] << value
        end
      else
         object["#{variable_name}".to_sym] = value
       end
    end
  end

  def assigned_variables
    variables = {}
    instance_variables.each do |var|
      variables[var] = instance_variable_get(var) unless instance_variable_get(var).nil? || instance_variable_get(var).empty?
    end
    variables
  end
end
