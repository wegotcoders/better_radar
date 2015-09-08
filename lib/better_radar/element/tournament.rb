module BetterRadar::Element

  class Tournament < Entity

    attr_accessor :names, :betradar_tournament_id, :betradar_sport_id, :betradar_category_id

    def initialize
      self.names = []
    end

    def assign_attributes(attributes, current_element, context)
      attributes.each do |attribute|
        case attribute.first
        when "BetradarTournamentID"
          self.betradar_tournament_id = attribute.last
        when "Language"
          self.names.last.merge!(language: attribute.last)
        when "name"
        else
          warn "#{self.class} :: attribute: #{attribute.first} on #{current_element} not supported"
        end
      end
    end

    def assign_content(content, current_element, context)
      case current_element
      when "Value"
        self.names.last[:name] =  content
      else
        warn "#{self.class} :: Current Element: #{current_element} - content not supported"
      end
    end
  end

end
