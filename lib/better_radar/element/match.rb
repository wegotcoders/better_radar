class BetterRadar::Element::Match < BetterRadar::Element::Entity

  attr_accessor :betradar_match_id, :competitors, :bets, :bet_results, :date, :scores, :result_comment, :goals, :cards, :probabilities

  def initialize
    self.competitors = []
    self.bets = []
    self.scores = []
    self.goals = []
    self.cards = []
    self.bet_results = []
    self.probabilities = []
  end

   # Oh good good refactor this
   # at the very least case the element not the attribute
  def assign_attributes(attributes, current_element, context)
    attributes.each do |attribute|
      case attribute.first
      when "BetradarMatchID"
        self.betradar_match_id = attribute.last
      when "ID", "SUPERID"
        self.competitors.last[attribute.first.downcase.to_sym] = attribute.last
      when "Type"
        if context.include?("Goal")
          self.goals.last.type = attribute.last
        elsif context.include?("Competitors")
          self.competitors.last[:type] = attribute.last
        elsif context.include?("Score")
          self.scores.last[:type] = attribute.last
        elsif context.include?("Card")
          self.cards.last.type = attribute.last
        elsif context.include?("PR")
        end
      when "OddsType"
        if context.include?("MatchOdds")
          self.bets.last.type = attribute.last
        elsif context.include?("BetResult")
          self.bet_results.last.type = attribute.last
        elsif context.include?("PR")
          self.probabilities.last.type = attribute.last
        end
      when "OutCome"
        if context.include?("MatchOdds")
          self.bets.last.odds.last.outcome = attribute.last
        elsif context.include?("BetResult")
          self.bet_results.last.outcome = attribute.last
        elsif context.include?("P")
          self.probabilities.last.outcome_probabilities.last[:outcome] = attribute.last
        end
      when "Id"
        if current_element == "Goal"
          self.goals.last.id = attribute.last
        elsif current_element == "Card"
          self.cards.last.id = attribute.last
        elsif current_element == "Player"
          if context.include?("Goal")
            self.goals.last.player.id = attribute.last
          elsif context.include?("Card")
            self.cards.last.player.id = attribute.last
          end
        end
      when "ScoringTeam"
        self.goals.last.scoring_team = attribute.last
      when "Team1"
        self.goals.last.team1 = attribute.last
      when "Team2"
        self.goals.last.team2 = attribute.last
      when "Time"
        if current_element == "Goal"
          self.goals.last.time = attribute.last
        elsif current_element == "Card"
          self.cards.last.time = attribute.last
        end
      when "Name"
        if context.include?("Goal")
          self.goals.last.player.name = attribute.last
        elsif context.include?("Card")
          self.cards.last.player.name = attribute.last
        end
      when "SpecialBetValue"
        if context.include?("BetResult")
          self.bet_results.last.special_value = attribute.last
        elsif context.include?("Probabilities")
          self.probabilities.last.outcome_probabilities.last[:special_value] = attribute.last
        end
      when "Status"
        self.bet_results.last.status = attribute.last
      when "VoidFactor"
        self.bet_results.last.void_factor = attribute.last
      else
        warn "#{self.class} :: attribute: #{attribute.first} on #{current_element} not supported"
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
        self.competitors.last[:name] = content
      elsif context.include?("Comment")
        self.result_comment = content
      end
    when "MatchDate"
      self.date.nil? ? self.date = "#{content} " : self.date << content
    when "P"
      self.probabilities.last.outcome_probabilities.last[:value] = content
    else
      warn "#{self.class} :: Current Element: #{current_element} - content not supported"
    end
  end

end
