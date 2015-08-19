class BetterRadar::Document < Nokogiri::XML::SAX::Document

  def initialize(handler)
    @handler = handler
  end

  def start_element(name, attributes)
    case name
    when 'Tournament'
      @tournament = {
        texts: []
      }
    when 'Match'
      @match = {
        competitors: []
      }
    when 'Text', 'Competitors'
      instance_variable_set("@inside_#{name.downcase}", true)
    end
  end

  def characters(text)
    content = text.strip.chomp
    if @inside_text && !content.empty?
      @tournament[:texts] << content if @tournament && !@match
      @match[:competitors] << content if @match && @inside_competitors
    end
  end

  def end_element(name)
    case name
    when 'Tournament'
      @handler.send(:handle_tournament, @tournament) if @handler.respond_to? :handle_tournament
    when 'Match'
      # TODO - This belongs elsewhere...
      @match[:competitors].uniq!
      @handler.send(:handle_match, @match) if @handler.respond_to? :handle_match
    when 'Text', 'Competitors'
      instance_variable_set("@inside_#{name.downcase}", false)
    end
  end
end