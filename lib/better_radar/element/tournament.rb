class BetterRadar::Element::Tournament < BetterRadar::Element::Base

  attr_accessor :names, :betradar_tournament_id

  def initialize
    self.names = []
  end

  def assign_attributes(attributes, current_element = nil)
    attributes.each do |attribute|
      case attribute.first
      when "BetradarTournamentID"
        self.betradar_tournament_id = attribute.last
      when "Language"
        self.names.last.merge!(language: attribute.last)
      when "name"
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
