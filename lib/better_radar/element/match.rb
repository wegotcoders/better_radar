class BetterRadar::Element::Match < BetterRadar::Element::Entity

  attr_accessor :betradar_match_id,
                :betradar_sport_id,
                :betradar_category_id,
                :betradar_tournament_id,
                :off,
                :sport_id,
                :round,
                :live_multi_cast,
                :live_score,
                :competitors,
                :bets,
                :bet_results,
                :date,
                :scores,
                :result_comment,
                :tv_info,
                :goals,
                :cards,
                :probabilities,
                :neutral_ground,
                :betfair_ids,
                :has_statistics

  def initialize
    self.competitors = []
    self.bets = []
    self.scores = []
    self.goals = []
    self.cards = []
    self.bet_results = []
    self.probabilities = []
    self.betfair_ids = {}
    self.tv_info = {}
    self.round = BetterRadar::Element::Round.new
  end

   # Oh good god refactor this
  def assign_attributes(attributes, current_element, context)
    attributes.each do |attribute|
      attribute_name = attribute.first
      attribute_value = attribute.last

      case attribute_name
      when "BetradarMatchID"
        assign_variable(:betradar_match_id, attribute_value)
      when "SUPERID"
        if context.include? 'Competitors'
          assign_variable :superid, attribute_value, object: competitors.last
        else
          raise "#{attribute_value} not supported on #{current_element}"
        end
      when "ID"
        if context.include? "Competitors"
          assign_variable :id, attribute_value, object: competitors.last
        else
          warn "#{attribute_name} not supported on #{current_element}"
        end
      when "Language"
        if context.include? 'Competitors'
          assign_variable(:language, attribute_value, object: competitors.last.names.last)
        else
          raise "#{attribute_value} not supported on #{current_element}"
        end
      when "Type"
        object = case
        when context.include?("Goal")
          goals.last
        when context.include?("Competitors")
          competitors.last
        when context.include?("Score")
          scores.last
        when context.include?("Card")
          cards.last
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:type, attribute_value, object: object)
      when "OddsType"
        object = case
        when context.include?("MatchOdds")
          bets.last
        when context.include?("BetResult")
          bet_results.last
        when context.include?("PR")
          probabilities.last
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:type, attribute_value, object: object)
      when "OutCome"
        object = case
        when context.include?("MatchOdds")
          bets.last.odds.last
        when context.include?("BetResult")
          bet_results.last
        when context.include?("P")
          probabilities.last.outcome_probabilities.last
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:outcome, attribute_value, object: object)
      when "OutComeId"
        object = case
        when context.include?("Odds")
          bets.last.odds.last
        when context.include?("P")
          probabilities.last.outcome_probabilities.last
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:outcome_id, attribute_value, object: object)
      when "Id"
        object = case
        when current_element == "Goal"
          goals.last
        when current_element == "Card"
          cards.last
        when current_element == "Player"
          if context.include?("Goal")
            goals.last.player
          elsif context.include?("Card")
            cards.last.player
          else
            raise "#{attribute_name} not supported on #{current_element}"
          end
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:id, attribute_value, object: object)
      when "ScoringTeam"
        assign_variable(:scoring_team, attribute_value, object: goals.last)
      when "Team1"
        assign_variable(:team1, attribute_value, object: goals.last)
      when "Team2"
        assign_variable(:team2, attribute_value, object: goals.last)
      when "Time"
        object = case
        when current_element == "Goal"
          goals.last
        when current_element == "Card"
          cards.last
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:time, attribute_value, object: object)
      when "Name"
        object = case
        when context.include?("Goal")
          goals.last.player
        when context.include?("Card")
          cards.last.player
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:name, attribute_value, object: object)
      when "SpecialBetValue"
        object = case
        when context.include?("BetResult")
          bet_results.last
        when context.include?("Probabilities")
          probabilities.last.outcome_probabilities.last
        when current_element == "Odds"
          bets.last.odds.last
        else
          raise "#{attribute_name} not supported on #{current_element}"
        end
        assign_variable(:special_value, attribute_value, object: object)
      when "Status"
        self.bet_results.last.status = attribute_value
      when "VoidFactor"
        self.bet_results.last.void_factor = attribute_value
      else
        raise "#{self.class} :: attribute: #{attribute_name} on #{current_element} not supported"
      end
    end
  end

  def assign_content(content, current_element, context)
    case current_element
    when "Value"
      if context.include?("Competitors")
        self.competitors.last.names << {} if self.competitors.last.names.empty?
        self.competitors.last.names.last[:name] = content
      elsif context.include?("Comment")
        self.result_comment = content
      elsif context.include?("HasStatistics")
        self.has_statistics = content
      elsif context.include?("NeutralGround")
        self.neutral_ground = content
      else
        raise "Content not supported in context -- #{context}"
      end
    when "ID"
      if context.include?("RoundInfo")
        self.round.id = content
      else
        raise "Content not supported in context -- #{context}"
      end
    when "MatchDate"
      self.date.nil? ? self.date = "#{content}" : self.date << content
    when "P"
      self.probabilities.last.outcome_probabilities.last[:value] = content
    when "Odds"
      self.bets.last.odds.last.value = content
    when "Score"
      self.scores.last.merge!(value: content)
    when "Off"
      self.off = content
    when "LiveMultiCast"
      self.live_multi_cast = content
    when "LiveScore"
      self.live_score = content
    when "Round"
      self.round.number = content
    when "Cupround"
      self.round.cup_round = content
    when "NeutralGround"
      self.neutral_ground = content
    when "SportID"
      self.betfair_ids[:sport_id] = content
    when "EventID"
      self.betfair_ids[:event_id] = content
    when "Runner1"
      self.betfair_ids[:runner1] = content
    when "Runner2"
      self.betfair_ids[:runner2] = content
    when "ChannelID"
      self.tv_info[:channel_id] = content
    when "ChannelName"
      self.tv_info[:channel_name].nil? ? self.tv_info[:channel_name] = "#{content} " : self.tv_info[:channel_name] << content
    when "StartDate"
      self.tv_info[:start_date].nil? ? self.tv_info[:start_date] = "#{content} " : self.tv_info[:start_date] << content
    else
        raise "Content not supported in context -- #{context}"
    end
  end

end
