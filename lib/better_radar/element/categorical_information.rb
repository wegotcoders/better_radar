module BetterRadar::Element
  module CategoricalInformation

    def retrieve_name(language = nil)
      preferred_language ||= language || BetterRadar.configuration.language
      self.names.find { |name| name[:language] == preferred_language }[:name]
    end

  end
end
