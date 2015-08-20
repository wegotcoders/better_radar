class BetterRadar::Document < Nokogiri::XML::SAX::Document

  # Main hierarchy of the data, these should be the focus of what to handle
  HIERARCHY_LEVELS = [:Sport, :Category, :Tournament, :Match]

  def initialize(handler)
    @handler = handler
  end

  def start_document
    @current_level = []
  end

  def start_element(name, attributes)
    descend_level(name)
    case name
    when 'Sport'
      @sport = {
        texts: []
      }
    when 'Category'
      @category = {
        texts: []
      }
    when 'Tournament'
      @tournament = {
        texts: []
      }
    when 'Match'
      @match = {
        texts: []
      }
    when 'Text'
      instance_variable_set("@inside_#{name.downcase}", true)
      current_level_data[:texts] << {}
      assign_attributes(attributes)
    end
  end

  def characters(text)
    content = text.strip.chomp
    if @inside_text && !content.empty?
      current_level_data[:texts].last.merge!({ name: content }) unless current_level_data.nil?
    end
  end

  def end_element(name)
    ascend_level(name)
    case name
    when 'Sport'
      @handler.send(:handle_sport, @sport) if @handler.respond_to? :handle_sport
    when 'Tournament'
      @handler.send(:handle_tournament, @tournament) if @handler.respond_to? :handle_tournament
    when 'Category'
      @handler.send(:handle_category, @category) if @handler.respond_to? :handle_category
    when 'Match'
      @handler.send(:handle_match, @match) if @handler.respond_to? :handle_match
    when 'Text'
      instance_variable_set("@inside_#{name.downcase}", false)
    end
  end

  private

    #attributes are stored as an assoc_list e.g. [["language", "BET"], ["language", "en"]]
  def assign_attributes(attrs)
    unless attrs.empty?
      attrs.each do |assoc_list|
        current_level_data[:texts].last.merge!({assoc_list.first.downcase.to_sym => assoc_list.last})
      end
    end
  end

  def current_level_data
    instance_variable_get("@#{@current_level.last.downcase}")
  end


  def descend_level(element_name)
    @current_level << element_name if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end

  def ascend_level(element_name)
    @current_level.pop if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end
end
