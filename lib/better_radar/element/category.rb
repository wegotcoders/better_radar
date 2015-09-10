module BetterRadar::Element

  class Category < Entity

    include BetterRadar::Element::CategoricalInformation

    attr_accessor :betradar_category_id, :betradar_sport_id, :names

    def initialize
      self.names = []
    end

    def assign_attributes(attributes, current_element, context)
      attributes.each do |attribute|
        case attribute.first
        when "BetradarCategoryID"
          self.betradar_category_id = attribute.last
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
