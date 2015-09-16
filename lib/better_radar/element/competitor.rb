module BetterRadar::Element

  class Competitor < BetterRadar::Element::Base

    include BetterRadar::Element::CategoricalInformation

    attr_accessor :context_id, :betradar_super_id, :type, :names

    def initialize
      @names = []
    end

    def betradar_id
      betradar_super_id
    end

    def betradar_id=(id)
      betradar_super_id = id
    end
  end

end
