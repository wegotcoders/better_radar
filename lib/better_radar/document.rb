class BetterRadar::Document < Nokogiri::XML::SAX::Document

  def initialize(handler)
    @handler = handler
  end

  def start_element(name, attributes)
    case name
    when 'Tournament'
      @handler.handle_tournament
    end

  end

end