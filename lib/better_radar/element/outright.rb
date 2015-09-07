class BetterRadar::Element::Outright < BetterRadar::Element::Entity

  attr_accessor :off, :tournament_id, :betradar_outright_id, :competitors, :bet, :results, :event_date, :event_end_date, :event_names, :aams_outright_ids

  def initialize
    self.competitors = []
    self.event_names = []
    self.aams_outright_ids = []
    self.results = []
  end

  def assign_attributes(attributes, current_element, context)
    # trying new format
    attributes.each do |attribute|
      attribute_name = attribute.first
      attribute_value = attribute.last

      case attribute_name
      when 'BetradarOutrightID'
        assign_variable(:betradar_outright_id, attribute_value)
      when 'SUPERID'
        if context.include? 'Competitors'
          assign_variable :superid, attribute_value, :object => competitors.last
        else
          warn "#{attribute_name} not supported on #{current_element}"
        end
      when 'OddsType'
        assign_variable :type, attribute_value, :object => bet
      when 'ID'
         object = case current_element
        when 'Odds'
          bet.odds.last
        when 'Result'
          results.last
        when 'Text'
          competitors.last
        else
          warn "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable :id, attribute_value, :object => object
      when 'Language'
        object = case
        when context.include?('Competitors')
          competitors.last.names.last
        when context.include?('EventName')
         event_names.last
        else
          warn "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable :language, attribute_value, :object => object
      else
        warn "#{self.class} :: attribute: #{attribute.first} on #{current_element} not supported"
      end
    end
  end

  def assign_content(content, current_element, context)
    case current_element
    when 'EventDate'
      assign_variable :event_date, content, :append => true
    when 'EventEndDate'
      assign_variable :event_end_date, content, :append => true
    when 'Value'
      if context.include?('EventName')
        assign_variable(:value, content, :object => event_names.last, :append => true)
      elsif context.include?('Competitors')
        # supporting single and multi language syntax
        self.competitors.last.names << {} if self.competitors.last.names.empty?
        if self.competitors.last.names.last[:name].nil?
          self.competitors.last.names.last[:name] = "#{content}"
        else
          self.competitors.last.names.last[:name] << content
        end
      else
        warn "Content not supported in context -- #{context}"
      end
    when 'AAMSOutrightId'
      self.aams_outright_ids << content
    when 'Off'
      assign_variable :off, content
    when 'TournamentId'
      assign_variable :tournament_id, content
    when 'Odds'
      assign_variable :value, content, :object => bet.odds.last
    when 'Result'
      results.last[:position] = content
    else
      warn "#{self.class} :: Current Element: #{current_element} - content not supported"
    end
  end
end
