class BetterRadar::Element::Match < BetterRadar::Element::Entity

  attr_accessor :betradar_match_id,
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
                :betfair_ids

  def initialize
    self.competitors = []
    self.bets = []
    self.scores = []
    self.goals = []
    self.cards = []
    self.bet_results = []
    self.probabilities = []
    self.round = {}
    self.betfair_ids = {}
    self.tv_info = {}
  end

   # Oh good god refactor this
  def assign_attributes(attributes, current_element, context)

    attributes.each do |attribute|
      attribute_name = attribute.first
      attribute_value = attribute.last

      case attribute_name
      when "BetradarMatchID"
        assign_variable(:betradar_match_id, attribute_value)
      when "ID", "SUPERID"
        if context.include?("Competitors")
          self.competitors.last.send("#{attribute_name.downcase}=".to_sym, attribute_value)
        end
      when "Language"
        if context.include?("Competitors")
          self.competitors.last.names.last[:language] = attribute_value
        end
      when "Type"
        if context.include?("Goal")
          self.goals.last.type = attribute_value
        elsif context.include?("Competitors")
          self.competitors.last.type = attribute_value
        elsif context.include?("Score")
          self.scores.last[:type] = attribute_value
        elsif context.include?("Card")
          self.cards.last.type = attribute_value
        elsif context.include?("PR")
        end
      when "OddsType"
        if context.include?("MatchOdds")
          self.bets.last.type = attribute_value
        elsif context.include?("BetResult")
          self.bet_results.last.type = attribute_value
        elsif context.include?("PR")
          self.probabilities.last.type = attribute_value
        end
      when "OutCome"
        if context.include?("MatchOdds")
          self.bets.last.odds.last.outcome = attribute_value
        elsif context.include?("BetResult")
          self.bet_results.last.outcome = attribute_value
        elsif context.include?("P")
          self.probabilities.last.outcome_probabilities.last[:outcome] = attribute_value
        end
      when "OutComeId"
        if context.include?("Odds")
          self.bets.last.odds.last.outcome_id = attribute_value
        elsif context.include?("P")
          self.probabilities.last.outcome_probabilities.last[:outcome_id] = attribute_value
        end
      when "Id"
        if current_element == "Goal"
          self.goals.last.id = attribute_value
        elsif current_element == "Card"
          self.cards.last.id = attribute_value
        elsif current_element == "Player"
          if context.include?("Goal")
            self.goals.last.player.id = attribute_value
          elsif context.include?("Card")
            self.cards.last.player.id = attribute_value
          end
        end
      when "ScoringTeam"
        self.goals.last.scoring_team = attribute_value
      when "Team1"
        self.goals.last.team1 = attribute_value
      when "Team2"
        self.goals.last.team2 = attribute_value
      when "Time"
        if current_element == "Goal"
          self.goals.last.time = attribute_value
        elsif current_element == "Card"
          self.cards.last.time = attribute_value
        end
      when "Name"
        if context.include?("Goal")
          self.goals.last.player.name = attribute_value
        elsif context.include?("Card")
          self.cards.last.player.name = attribute_value
        end
      when "SpecialBetValue"
        if context.include?("BetResult")
          self.bet_results.last.special_value = attribute_value
        elsif context.include?("Probabilities")
          self.probabilities.last.outcome_probabilities.last[:special_value] = attribute_value
        end
      when "Status"
        self.bet_results.last.status = attribute_value
      when "VoidFactor"
        self.bet_results.last.void_factor = attribute_value
      else
        warn "#{self.class} :: attribute: #{attribute_name} on #{current_element} not supported"
      end
    end
  end

  def assign_content(content, current_element, context)
    case current_element
    when "Odds"
      self.bets.last.odds.last.value = content
    when "Score"
      self.scores.last.merge!(value: content)
    when "Value"
      if context.include?("Competitors")
        self.competitors.last.names << {} if self.competitors.last.names.empty?
        self.competitors.last.names.last[:name] = content
      elsif context.include?("Comment")
        self.result_comment = content
      end
    when "MatchDate"
      self.date.nil? ? self.date = "#{content}" : self.date << content
    when "P"
      self.probabilities.last.outcome_probabilities.last[:value] = content
      #TODO: Dry this up
    when "Off"
      self.off = content
    when "LiveMultiCast"
      self.live_multi_cast = content
    when "LiveScore"
      self.live_score = content
    when "Round"
      self.round.number = content
    when "ID"
      if context.include?("RoundInfo")
        self.round.id = content
      else
        warn "ID not supported in context : #{context}"
      end
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
      warn "#{self.class} :: Current Element: #{current_element} - content not supported"
    end
  end

end
