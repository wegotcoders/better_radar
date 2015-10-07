module BetterRadar::Element

  class Competitor < BetterRadar::Element::Base

    include BetterRadar::Element::CategoricalInformation
    include BetterRadar::Element::Storable

    attr_accessor :context_id, :betradar_super_id, :type, :names

    def initialize
      @names = []
    end

    def key_name
      "competitor"
    end

    def betradar_id
      betradar_super_id
    end

    def betradar_id=(id)
      betradar_super_id = id
    end
  end

end
