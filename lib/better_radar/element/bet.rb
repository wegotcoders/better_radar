class BetterRadar::Element::Bet

  attr_accessor :type, :odds, :outcome

  def initialize
    self.odds = []
  end
end
