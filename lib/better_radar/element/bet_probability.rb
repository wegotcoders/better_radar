class BetterRadar::Element::BetProbability < BetterRadar::Element::Base

  attr_accessor :type, :outcome_probabilities

  def initialize
    self.outcome_probabilities = []
  end
end
