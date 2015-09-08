module BetterRadar::Element

  class Competitor < BetterRadar::Element::Base

    attr_accessor :id, :superid, :type, :names

    def initialize
      @names = []
    end
  end

end
