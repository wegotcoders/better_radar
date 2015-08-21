class BetterRadar::Document < Nokogiri::XML::SAX::Document

  # Main hierarchy of the data, these should be the focus of what to handle
  HIERARCHY_LEVELS = [:Sport, :Category, :Tournament, :Match]

  def initialize(handler)
    @handler = handler
  end

  def start_document
    @traversal_list = []
  end

  # need to notify the handler of this so they can prepare for nested elements?
  def start_element(name, attributes)
    @current_element = name
    descend_level(name)
    case name
    when 'Sport', 'Category', 'Tournament'
      instance_variable_set("@#{name.downcase}", { texts: [] })
      assign_attributes(name, attributes)
    when 'Match'
      instance_variable_set("@match",
        {
          fixture: { competitors: nil },
          match_odds: [],
          result: {},
          goals: [],
          cards: []
        }
      )
      assign_attributes(name, attributes)
    when 'Competitors'
      @inside_competitors = true
      @competitors = []
      assign_attributes(name, attributes)
    when 'DateInfo'
      @inside_date_info = true
      @match[:fixture][:dateinfo] = {}
    when 'MatchDate'
      @inside_match_date = true
    when 'MatchOdds'
      @inside_match_odds = true
      @match_odds = []
    when 'Bet'
      @inside_bet = true
      @bet = { odds: [] }
      if @inside_match_odds
        @match_odds << @bet
      end
      assign_attributes(name, attributes)
    when 'Odds'
      @inside_odds = true
      @odds = {}
      if @inside_match_odds
        @bet[:odds] << @odds
      end
      assign_attributes(name, attributes)
    when 'Text'
      @inside_text = true
      if @inside_competitors
        @competitors << {}
        assign_attributes(name, attributes)
      elsif @inside_match_odds
        @match_odds << {}
      else
        current_level_data[:texts] << {} if current_level_data[:texts]
        assign_attributes(name, attributes)
      end
    end
  end

  def end_element(name)
    case name
    when 'Sport', 'Category', 'Tournament', 'Match'
      method_name = "handle_#{current_level_name}".to_sym
      @handler.send(method_name, current_level_data) if @handler.respond_to? method_name
    when 'Competitors'
      @inside_competitors = false
    when 'DateInfo'
      @inside_date_info = false
    when 'MatchDate'
      @inside_match_date = false
    when 'Fixture'
      @match[:fixture][:competitors] = @competitors if @competitors && !@match.empty?
      @match[:fixture][:dateinfo][:matchdate] = @match_date if @match_date && !@match.empty?
    when 'MatchOdds'
      @match[:match_odds] = @match_odds if @match_odds && !@match.empty?
      @inside_match_odds = false
    when 'Bet'
      @inside_bet = false
    when 'Odd'
      @inside_odds = false
    when 'Text'
      @inside_text =  false
    end
    ascend_level(name)
  end

  def characters(text)
    content = text.strip.chomp
    unless content.empty?
      if @inside_competitors
        @competitors.last.merge!({ name: content })
      elsif @inside_match_odds
        #ewww
        #match odds with many bets, with many odds
         @bet[:odds].last.merge!({ value: content })
      elsif @inside_match_date
        @match_date.nil? ? @match_date = "#{content} " : @match_date << content
      else
        #to fix
        current_level_data[:texts].last.merge!({ name: content }) unless current_level_data.nil? || current_level_data[:texts].nil?
      end
    end
  end


  private

    #attributes are stored as an assoc_list e.g. [["language", "BET"], ["language", "en"]]
  def assign_attributes(element, attrs)
    unless attrs.empty?

      path = case element
      when 'Text'
        if @inside_competitors
          @competitors.last
        else
          current_level_data[:texts].last
        end
      when 'Bet'
        @bet
      when 'Odds'
        @odds
      else
        current_level_data
      end
      attrs.each do |assoc_list|
        path.merge!({assoc_list.first.downcase.to_sym => assoc_list.last})
      end

    end
  end

  def current_level_data
    instance_variable_get("@#{@traversal_list.last.downcase}")
  end

  def current_level_name
    @traversal_list.last.downcase
  end


  def descend_level(element_name)
    @traversal_list << element_name if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end

  def ascend_level(element_name)
    @traversal_list.pop if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end
end
