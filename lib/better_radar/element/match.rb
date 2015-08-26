class BetterRadar::Element::Match < BetterRadar::Element::Base

  attr_accessor :betradar_match_id, :competitors, :bets, :date, :scores, :result_comment, :goals, :cards

  def initialize
    self.competitors = []
    self.bets = []
    self.scores = []
    self.goals = []
    self.cards = []
  end

  def assign_attributes(attributes, current_element = nil, context = nil)
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
        end
      when "OddsType"
        self.bets.last.type = attribute.last
      when "OutCome"
        self.bets.last.odds.last.outcome = attribute.last
      when "Id"
        if current_element == "Goal"
          self.goals.last.id = attribute.last
        elsif current_element == "Card"
          binding.pry
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
      else
        raise "attribute #{attribute.first} not supported"
      end
    end
  end

  def assign_content(content, current_element = nil, context = nil)
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
    else
      warn "#{current_element} - #{content} not assigned"
    end
    # @match_date.nil? ? @match_date = "#{content} " : @match_date << content
  end

end
