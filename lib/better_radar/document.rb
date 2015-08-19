class BetterRadar::Document < Nokogiri::XML::SAX::Document

  def initialize(handler)
    @handler = handler
  end

  def start_element(name, attributes)
    case name
    when 'Tournament', 'Match', 'Odds'
      method_name = "handle_#{name.downcase}"
      @handler.send(method_name) if @handler.respond_to? method_name
    end
  end
end