class BetterRadar::Document < Nokogiri::XML::SAX::Document

  attr_accessor :hierarchy_levels, :sport, :category, :tournament, :outright, :match
  # These elements have their own classes to container their respective data

  attr_reader :start_time

  ENTITY_ELEMENTS = [:Sport, :Category, :Outright, :Tournament, :Match]

  def initialize(handler)
    @handler = handler
  end

  # Parsing Events

  def start_document
    @start_time = Time.now
    @hierarchy_levels = []
    @traversal_list = []
  end

  def start_element(name, attributes)
    descend_into_element(name)
    handle_element(name, attributes)
  end

  def end_element(name)
    ascend_depth(name)
    send_handler_data(name)
  end

  def characters(text)
    content = text.strip.chomp
    unless content.empty?
      current_level_data.assign_content(content, @current_element, @traversal_list)
    end
  end

  private

  # Traversal representations

  def descend_into_element(name)
    @current_element = name
    instance_variable_set("@inside_#{@current_element.downcase}", true)
    @traversal_list << @current_element
    @hierarchy_levels << @current_element if ENTITY_ELEMENTS.include?(@current_element.to_sym)
  end

  def ascend_depth(name)
    instance_variable_set("@inside_#{name.downcase}", false)
    @traversal_list.pop
    @hierarchy_levels.pop if ENTITY_ELEMENTS.include?(@current_element.to_sym)
  end

  # Establishing data structures

  def handle_element(name, attributes)
    case name
    when 'Sports', 'BetradarBetData'
      #skip?
    else
      create_variable(name)
      establish_assocation(name)
      assign_attributes(name, attributes)
    end
  end

  # Attributes are parsed as an assoc_list e.g. [["language", "BET"], ["language", "en"]]
  # TODO: convert to hash for easier use?

  def assign_attributes(name, attributes)
    unless attributes.empty?
      unless name == 'Timestamp'
        @element = current_level_data

        if @element.respond_to?(:assign_attributes)
          @element.assign_attributes(attributes, @current_element, @traversal_list)
        else
          warn("#{name} - #{attributes} not being assigned")
        end
      else
        attributes.each do |attribute|
          @timestamp[attribute.first.to_sym] = attribute.last
        end
      end
    end
  end

  def current_level_data
    instance_variable_get("@#{@hierarchy_levels.last.downcase}")
  end

  def get_level_data(name)
    instance_variable_get("@#{name.downcase}")
  end

  def current_level_name
    @hierarchy_levels.last.downcase
  end

  def create_variable(element_name)
    variable_name = "@#{element_name.downcase}"

    case element_name
    when 'Sport', 'Category', 'Tournament', 'Match', 'Outright', 'Bet', 'Odds', 'Goal', 'Player', 'Card', 'W', 'PR', 'OutrightOdds', 'RoundInfo'
      instance_variable_set(variable_name, BetterRadar::Element::Factory.create_from_name(element_name))
    when 'Texts'
      if @inside_competitors
        instance_variable_set("@competitor", BetterRadar::Element::Factory.create_from_name("Competitor"))
      end
    when 'Score', 'Bet', 'P', 'Value', 'Timestamp'
      instance_variable_set("@#{element_name.downcase}", {})
    end
  end

  # TODO: Refactor approach to this
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
    when 'Texts'
      if @inside_competitors
        @competitors << @competitor
      end
    when 'Text'
      if @inside_eventname
        current_level_data.event_names << {}
      elsif @inside_competitors
        @competitors.last.names << {}
      else
        current_level_data.names << {} unless current_level_data == @match || current_level_data == @outright
      end
    when 'Result'
      if @inside_outrightresult
        @outright.bet_results << {}
      end
    when 'RoundInfo'
      if @inside_match
        @match.round = @roundinfo
      end
    when 'Value'
    end
  end

  def recent_data?
    Time.parse(@time_stamp[:CreatedAt]) > @start_time - 1.days
  end

  def send_data?
    if BetterRadar.configuration.only_recent?
      recent_data?
    else
      true
    end
  end

  def send_handler_data(name)
    if ENTITY_ELEMENTS.include?(name.to_sym) && send_data?
      entity = instance_variable_get("@#{name.downcase}")
      assign_parent_data(entity)
      method_name = "handle_#{name.downcase}".to_sym
      @handler.send(method_name, entity)
    end
  end

  def assign_parent_data(entity)
    @hierarchy_levels.each do |level|
      break if level == @hierarchy_levels.last
      variable_name = "@betradar_#{level.downcase}_id"
      entity.instance_variable_set(variable_name, get_level_data(level).instance_variable_get(variable_name))
    end
  end
end
