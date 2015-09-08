class BetterRadar::Element::Factory

  def self.create_from_name(name)
    case name
    when 'Sport'
      BetterRadar::Element::Sport.new
    when 'Category'
      BetterRadar::Element::Category.new
    when 'Tournament'
      BetterRadar::Element::Tournament.new
    when 'Outright'
      BetterRadar::Element::Outright.new
    when 'Match'
      BetterRadar::Element::Match.new
    when 'Card'
      BetterRadar::Element::Card.new
    when 'Goal'
      BetterRadar::Element::Goal.new
    when 'Player'
      BetterRadar::Element::Player.new
    when 'Bet', 'OutrightOdds'
      BetterRadar::Element::Bet.new
    when 'Odds'
      BetterRadar::Element::Odds.new
    when 'PR'
      BetterRadar::Element::BetProbability.new
    when 'W'
      BetterRadar::Element::BetResult.new
    when 'RoundInfo'
      BetterRadar::Element::Round.new
    when 'Competitor'
      BetterRadar::Element::Competitor.new
    else
      warn "Element Not Supported"
    end
  end
end
