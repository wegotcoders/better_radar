class BetterRadar::Element::Sport < BetterRadar::Element::Entity

  attr_accessor :betradar_sport_id, :names

  def initialize
    self.names = []
  end

  def assign_attributes(attributes, current_element = nil, context = nil)
    attributes.each do |attribute|
      case attribute.first
      when "BetradarSportID"
        self.betradar_sport_id = attribute.last
      when "Language"
        self.names.last.merge!(language: attribute.last)
      else
        raise "attribute #{attribute.first} not supported"
      end
    end
  end

  def assign_content(content, current_element = nil, context = nil)
    case current_element
    when "Value"
      self.names.last[:name] =  content
    end
  end


end
