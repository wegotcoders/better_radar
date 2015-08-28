class BetterRadar::Element::Sport < BetterRadar::Element::Entity

  attr_accessor :betradar_sport_id, :names

  def initialize
    self.names = []
  end

  def assign_attributes(attributes, current_element, context)
    attributes.each do |attribute|
      case attribute.first
      when "BetradarSportID"
        self.betradar_sport_id = attribute.last
      when "Language"
        self.names.last.merge!(language: attribute.last)
      else
        warn "#{self.class} :: attribute: #{attribute.first} on #{current_element} not supported"
      end
    end
  end

  def assign_content(content, current_element = nil, context = nil)
    case current_element
    when "Value"
      self.names.last[:name] =  content
    else
      warn "#{self.class} :: Current Element: #{current_element} - content not supported"
    end
  end


end
