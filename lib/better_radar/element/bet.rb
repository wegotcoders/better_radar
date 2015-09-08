class BetterRadar::Element::Bet < BetterRadar::Element::Base

  attr_accessor :type, :odds, :outcome

  def initialize
    self.odds = []
  end
end
