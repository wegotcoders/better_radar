class BetterRadar::Element::Sport < BetterRadar::Element::Base

  attr_accessor :betradar_sport_id, :names

  def initialize
    self.names = []
  end

  def assign_attributes(attributes, current_element = nil)
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

  def assign_content(content)
    content.each do |key, value|
      case key
      when :name
        self.names.last.merge!(content)
      end
    end
  end


end
