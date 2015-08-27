class BetterRadar::Element::BetProbability

  attr_accessor :type, :outcome_probabilities

  def initialize
    self.outcome_probabilities = []
  end
end
