class BetterRadar::Element::Outright < BetterRadar::Element::Entity

  attr_accessor :off, :tournament_id, :betradar_outright_id, :competitors, :bet, :result, :event_date, :event_names, :aams_outright_ids

  def initialize
    self.competitors = []
    self.event_names = []
    self.aams_outright_ids = []
  end

  def assign_attributes(attributes, current_element, context)
    # trying new format
    attributes.each do |attribute|
      name = attribute.first
      value = attribute.last

      case current_element
      when "Outright"
        self.betradar_outright_id = value if name == "BetradarOutrightID"
      when "Text"
        self.competitors.last[name.downcase.to_sym] = value if context.include?("Competitors")
      when "OutrightOdds"
        self.bet.type = value if name == "OddsType"
      when "Odds"
        self.bet.odds.last.id = value if name == "ID"
      when "Result"
        self.result = value
      else
        warn "#{self.class} :: attribute: #{attribute.first} on #{current_element} not supported"
      end
    end
  end

  def assign_content(content, current_element, context)
    case current_element
    when "EventDate"
      # why do I need a space after the first part?
      self.event_date.nil? ? self.event_date = "#{content} " : self.event_date << content
    when "Value"
      if context.include?("EventName")
        self.event_names.last[:value].nil? ? self.event_names.last[:value] = "#{content} " : self.event_names.last[:value] << content
      elsif context.include?("Competitors")
        # but not here
        self.competitors.last[:name].nil? ? self.competitors.last[:name] = "#{content}" : self.event_names.last[:value] << content
      end
    when "AAMSOutrightId"
      self.aams_outright_ids << content
    when "Off"
      self.off = content
    when "TournamentId"
      self.tournament_id = content
    when "Odds"
      self.bet.odds.last.value = content
    else
      warn "#{self.class} :: Current Element: #{current_element} - content not supported"
    end
  end
end
