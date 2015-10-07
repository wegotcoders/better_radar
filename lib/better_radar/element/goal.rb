module BetterRadar::Element

  class Goal < BetterRadar::Element::Base

    attr_accessor :id, :scoring_team, :team1, :team2, :time, :player

  end
end
