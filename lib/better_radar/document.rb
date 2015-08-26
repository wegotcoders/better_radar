class BetterRadar::Document < Nokogiri::XML::SAX::Document

  # Main hierarchy of the data, these should be the focus of what to handle
  HIERARCHY_LEVELS = [:Sport, :Category, :Tournament, :Match]

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

    descend_level(name)
    instance_variable_set("@inside_#{name.downcase}", true)

    case name
    when 'Sport', 'Category', 'Tournament', 'Match'
      instance_variable_set("@#{name.downcase}", BetterRadar::Element::Base.create_from_name(name))
      @sport = BetterRadar::Element::Sport.new
    when 'Category'
      @category = BetterRadar::Element::Category.new
    when 'Tournament'
      @tournament = BetterRadar::Element::Tournament.new
    when 'Match'
      @match = BetterRadar::Element::Match.new
    when 'Competitors'
      if @inside_match
        @competitors = @match.competitors
      elsif @inside_tournament
        @competitors = @tournament.competitors
      end
    when 'Bet'
      @bet = BetterRadar::Bet.new
      if @inside_match
        @match.bets << @bet
      end
    when 'Odds'
      @odds = BetterRadar::Odds.new
      if @inside_bet
        @bet.odds << @odds
      end
    when 'Score'
      @score = {}
      if @inside_match
        @match.scores << @score
      end
    when 'Goal'
      @goal = BetterRadar::Goal.new
      if @inside_match
        @match.goals << @goal
      end
    when 'Player'
      @player = BetterRadar::Player.new
      if @inside_goals
        @goal.player = @player
      elsif @inside_cards
        @card.player = @player
      end
    when 'Card'
      @card = BetterRadar::Card.new
      if @inside_match
        @match.cards << @card
      end
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
    end
    assign_attributes(name, attributes)
  end

  def end_element(name)
    case name
    when 'Sport', 'Category', 'Tournament', 'Match'
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
end
