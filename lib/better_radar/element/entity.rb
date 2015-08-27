class BetterRadar::Element::Entity
  # implement in subclasses
  def assign_attributes(attributes, current_element, context)
    warnraise "TODO: implement in subclass"
  end

  def assign_content(content, current_element, context)
    raise "TODO: implement in subclass"
  end
end
