class BetterRadar::Parser

  def self.parse(xml, handler)
    parser = Nokogiri::XML::SAX::Parser.new(BetterRadar::Document.new(handler))
    parser.parse xml
  end

end
