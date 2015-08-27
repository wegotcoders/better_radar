class BetterRadar::Element::Category < BetterRadar::Element::Entity
  attr_accessor :betradar_category_id, :names

  def initialize
    self.names = []
  end

  def assign_attributes(attributes, current_element = nil, context = nil)
    attributes.each do |attribute|
      case attribute.first
      when "BetradarCategoryID"
        self.betradar_category_id = attribute.last
      when "Language"
        self.names.last.merge!(language: attribute.last)
      when "name"
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
