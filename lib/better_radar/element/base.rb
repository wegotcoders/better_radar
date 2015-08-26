module BetterRadar::Element
  class Base

    def self.create_from_name(name)
      case name
      when 'Sport'
        BetterRadar::Element::Sport.new
      when 'Category'
        BetterRadar::Element::Category.new
      when 'Tournament'
        BetterRadar::Element::Tournament.new
      when 'Match'
        BetterRadar::Element::Match.new
      when 'Outright'
        #TODO
      end
    end

    # implement in subclasses
    def assign_attributes(attributes)
      warn "TODO: implement in subclass"
      nil
    end

    def assign_content(content)
      warn "TODO: implement in subclass"
      nil
    end
  end
end
