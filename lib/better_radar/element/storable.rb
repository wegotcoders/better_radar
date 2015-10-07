module BetterRadar::Element
  module Storable

    def as_storable
      {
        entity_type: self.key_name.downcase,
        name: self.retrieve_name,
        betradar_id: self.betradar_id
      }
    end
  end
end
