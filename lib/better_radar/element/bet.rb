module BetterRadar::Element

  class Bet < BetterRadar::Element::Base

    attr_accessor :type, :odds, :outcome

    def initialize
      self.odds = []
    end

    def type_description
      case type
      when '1'
        'Handicap'
      when '2'
        'Correct Score'
      when '10'
        '3-Way'
      when '20'
        '2-Way'
      when '60'
        'Totals'
      end
    end

    def key_name
      'bet'
    end
  end

end
