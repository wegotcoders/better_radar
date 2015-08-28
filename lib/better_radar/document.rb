class BetterRadar::Document < Nokogiri::XML::SAX::Document

  # Main hierarchy of the data, these should be the focus of what to handle

  HIERARCHY_LEVELS = [:Sport, :Category, :Outright, :Tournament, :Match]


  def initialize(handler)
    @handler = handler
  end

  def start_document
    @hierarchy_levels = []
    @traversal_list = []
  end

  # need to notify the handler of this so they can prepare for nested elements?
  def start_element(name, attributes)
    @current_element = name
    @traversal_list << @current_element

    create_variable(name)
    establish_assocation(name)

    descend_level(name)
    instance_variable_set("@inside_#{name.downcase}", true)

    assign_attributes(name, attributes)
  end

  def end_element(name)
    case name
    when 'Sport', 'Category', 'Tournament', 'Match', 'Outright'
      method_name = "handle_#{current_level_name}".to_sym
      @handler.send(method_name, current_level_data)
    end

    instance_variable_set("@inside_#{name.downcase}", false)
    @traversal_list.pop
    ascend_level(name)
  end

  def characters(text)
    content = text.strip.chomp
    unless content.empty?
      current_level_data.assign_content(content, @current_element, @traversal_list)
    end
  end

  private

    #attributes are stored as an assoc_list e.g. [["language", "BET"], ["language", "en"]]
  def assign_attributes(name, attributes)
    unless attributes.empty?
      @element = current_level_data

      if @element.respond_to?(:assign_attributes)
        @element.assign_attributes(attributes, @current_element, @traversal_list)
      else
        warn("#{name} - #{attributes} not being assigned")
      end
    end
  end

  def current_level_data
    instance_variable_get("@#{@hierarchy_levels.last.downcase}")
  end

  def current_level_name
    @hierarchy_levels.last.downcase
  end


  def descend_level(element_name)
    @hierarchy_levels << element_name if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end

  def ascend_level(element_name)
    @hierarchy_levels.pop if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end

  def create_variable(element_name)

    variable_name = "@#{element_name.downcase}"

    case element_name
    when 'Sport', 'Category', 'Tournament', 'Match', 'Outright', 'Bet', 'Odds', 'Goal', 'Player', 'Card', 'W', 'PR', 'OutrightOdds'
      instance_variable_set(variable_name, BetterRadar::Element::Factory.create_from_name(element_name))
    when 'Score', 'Bet', 'Competitors', 'P', 'Value'
      instance_variable_set("@#{element_name.downcase}", {})
    end
  end

  def establish_assocation(name)
    case name
    when 'Competitors'
      if @inside_match
        @competitors = @match.competitors
      elsif @inside_tournament
        @competitors = @tournament.competitors
      elsif @inside_outright
        @competitors = @outright.competitors
      end
    when 'OutrightOdds'
      @outright.bet = @outrightodds
    when 'Bet'
      if @inside_match
        @match.bets << @bet
      end
    when 'Odds'
      if @inside_bet
        @bet.odds << @odds
      elsif @inside_outrightodds
        @outright.bet.odds << @odds
      end
    when 'Score'
      if @inside_match
        @match.scores << @score
      end
    when 'Goal'
      if @inside_match
        @match.goals << @goal
      end
    when 'Player'
      if @inside_goals
        @goal.player = @player
      elsif @inside_cards
        @card.player = @player
      end
    when 'Card'
      if @inside_match
        @match.cards << @card
      end
    when 'W'
      if @inside_match
        @match.bet_results << @w
      end
    when 'PR'
      if @inside_match
        @match.probabilities << @pr
      end
    when 'P'
      @pr.outcome_probabilities << @p
    when 'Text'
      # most nested first
      if @inside_competitors
        @competitors << {}
      elsif @inside_tournament
        @tournament.names << {}
      elsif @inside_category
        @category.names << {}
      elsif @inside_sport
        @sport.names << {}
      end
    when 'Value'
      if @inside_eventname
        @outright.event_names << @value
      end
    end
  end
end
