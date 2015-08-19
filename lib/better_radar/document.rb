class BetterRadar::Document < Nokogiri::XML::SAX::Document

  def initialize(handler)
    @handler = handler
  end

  def start_element(name, attributes)
    case name
    when 'Tournament', 'Match'
      instance_variable_set("@last_#{name.downcase}", {
        texts: []
      })
    when 'Text'
      @inside_text = true
    end
  end

  def characters(text)
    if @inside_text && @last_tournament && !@last_match
      content = text.strip.chomp
      @last_tournament[:texts] << content unless content.empty?
    end
  end


  def end_element(name)
    case name
    when 'Tournament', 'Match', 'Odds'
      method_name = "handle_#{name.downcase}"
      @handler.send(method_name, @last_tournament) if @handler.respond_to? method_name
    when 'Text'
      @inside_text = false
    end
  end
end