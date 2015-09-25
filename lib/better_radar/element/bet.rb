module BetterRadar::Element

  class Bet < BetterRadar::Element::Base

    attr_accessor :type, :odds, :outcome

    def initialize
      self.odds = []
    end

    def key_name
      'bet'
    end
  end

end
