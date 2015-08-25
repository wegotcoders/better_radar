class BetterRadar::Document < Nokogiri::XML::SAX::Document

  # Main hierarchy of the data, these should be the focus of what to handle
  HIERARCHY_LEVELS = [:Sport, :Category, :Outright, :Tournament, :Match]

  def initialize(handler)
    @handler = handler
  end

  def start_document
    @traversal_list = []
  end

  # need to notify the handler of this so they can prepare for nested elements?
  def start_element(name, attributes)
    @current_element_name = name
    descend_level(name)
    instance_variable_set("@inside_#{name.downcase}", true)

    case name
    when 'Sport'
      @sport = {}
    when 'Category'
      @category = {}
    when 'Tournament'
      @tournament = {}
    when 'Outright'
      @outright = {}
    when 'Match'
      @match = {}
    when 'Fixture'
      @fixture = {}
      if @inside_match
        @match[:fixture] = @fixture
      elsif @inside_outright
        @outright[:fixture] = @fixture
      end
    when 'Competitors'
      @competitors = []
      if @inside_fixture
        @fixture[:competitors] = @competitors
      end
    when 'DateInfo'
      @date_info = {}
      if @inside_fixture
        @fixture[:date_info] = @date_info
      end
    when 'MatchDate'
      @match_date = nil
      @date_info[:match_date] = @match_date
    when 'MatchOdds'
      @match_odds = []
      @match[:match_odds] = @match_odds
    when 'Bet'
      @bet = {}
      if @inside_match
        @match_odds << @bet
      end
    when 'Odds'
      @odds = {}
      if @inside_bet
        @bet[:odds] ||= []
        @bet[:odds] << @odds
      end
    when 'Text'
      # most nested first
      if @inside_competitors
        @competitors << {}
      elsif @inside_tournament
        @tournament[:names] ||= []
        @tournament[:names] << {}
      elsif @inside_category
        @category[:names] ||= []
        @category[:names] << {}
      elsif @inside_sport
        @sport[:names] ||= []
        @sport[:names] << {}
      end
    end
    assign_attributes(name, attributes)
  end

  def end_element(name)
    case name
    when 'Sport', 'Category', 'Tournament', 'Match', 'Outright'
      method_name = "handle_#{current_level_name}".to_sym
      @handler.send(method_name, current_level_data) if @handler.respond_to? method_name
    when 'Fixture'
      if @inside_match
        @match[:fixture] = @fixture
      end
    when 'Competitors'
      if @inside_fixture
        @fixture[:competitors] = @competitors
      end
    when 'DateInfo'
      if @inside_fixture
        @fixture[:date_info] = @date_info
      end
    when 'MatchDate'
      @date_info[:match_date] = @match_date
    when 'MatchOdds'
      @match[:match_odds] = @match_odds
    when 'Bet'
      #
    when 'Odd'
      if @inside_bet
        @bet[:odds] << @odds
      end
    when 'Text'
      # Needed?
    end

    instance_variable_set("@inside_#{name.downcase}", false)
    instance_variable_set("@#{name.downcase}", nil)
    ascend_level(name)
  end

  def characters(text)
    content = text.strip.chomp
    unless content.empty?
      if @inside_competitors
        @competitors.last.merge!({ name: content })
      elsif @inside_matchodds
        @odds.merge!({ value: content })
      elsif @inside_statusinfo
        #TODO
      elsif @inside_neutralground
        #TODO
      elsif @inside_round
        #TODO
      elsif @inside_probabilities
        #TODO
      elsif @inside_matchdate
        @match_date.nil? ? @match_date = "#{content} " : @match_date << content
      elsif @inside_tournament
        @tournament[:names].last.merge!({ name: content })
      elsif @inside_category
        @category[:names].last.merge!({ name: content })
      elsif @inside_sport
        @sport[:names].last.merge!({ name: content })
      else
        #to fix
        # current_level_data[:texts].last.merge!({ name: content }) unless current_level_data.nil? || current_level_data[:texts].nil?
      end
    end
  end


  private

    #attributes are stored as an assoc_list e.g. [["language", "BET"], ["language", "en"]]
  def assign_attributes(name, attrs)
    unless attrs.empty?
      path = case name
      when 'Text'
        if @inside_competitors
          @competitors.last
        elsif @inside_tournament
          @tournament[:names].last
        elsif @inside_category
          @category[:names].last
        elsif @inside_sport
          @sport[:names].last
        end
      else
        v = instance_variable_get("@#{name.downcase}")
        return if v.nil?
        v
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
