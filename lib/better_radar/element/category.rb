class BetterRadar::Element::Category < BetterRadar::Element::Base

  attr_accessor :betradar_category_id, :names

  def initialize
    self.names = []
  end

  def assign_attributes(attributes)
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

  def assign_content(content)
    content.each do |key, value|
      case key
      when :name
        self.names.last.merge!(content)
      end
    end
  end


end
