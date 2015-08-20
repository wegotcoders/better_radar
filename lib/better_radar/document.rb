class BetterRadar::Document < Nokogiri::XML::SAX::Document

  # Main hierarchy of the data, these should be the focus of what to handle
  HIERARCHY_LEVELS = [:Sport, :Category, :Tournament, :Match]

  def initialize(handler)
    @handler = handler
  end

  def start_document
    @traversal_list = []
  end

  # need to notify the handler of this so they can prepare for nested elements?
  def start_element(name, attributes)
    descend_level(name)
    case name
    when 'Sport', 'Category', 'Tournament', 'Match'
      instance_variable_set("@#{name.downcase}", { texts: [] })
      assign_attributes(name, attributes)
    when 'Text'
      instance_variable_set("@inside_#{name.downcase}", true)
      current_level_data[:texts] << {}
      assign_attributes(name, attributes)
    end
  end

  def characters(text)
    content = text.strip.chomp
    if @inside_text && !content.empty?
      current_level_data[:texts].last.merge!({ name: content }) unless current_level_data.nil?
    end
  end

  def end_element(name)
    case name
    when 'Sport', 'Category', 'Tournament', 'Match'
      method_name = "handle_#{current_level_name}".to_sym
      @handler.send(method_name, current_level_data) if @handler.respond_to? method_name
    when 'Text'
      instance_variable_set("@inside_#{name.downcase}", false)
    end
    ascend_level(name)
  end

  private

    #attributes are stored as an assoc_list e.g. [["language", "BET"], ["language", "en"]]
  def assign_attributes(element, attrs)
    unless attrs.empty?
      case element
      when 'Text'
        attrs.each do |assoc_list|
          current_level_data[:texts].last.merge!({assoc_list.first.downcase.to_sym => assoc_list.last})
        end
      else
        attrs.each do |assoc_list|
          current_level_data.merge!({assoc_list.first.downcase.to_sym => assoc_list.last})
        end
      end
    end
  end

  def current_level_data
    instance_variable_get("@#{@traversal_list.last.downcase}")
  end

  def current_level_name
    @traversal_list.last.downcase
  end


  def descend_level(element_name)
    @traversal_list << element_name if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end

  def ascend_level(element_name)
    @traversal_list.pop if HIERARCHY_LEVELS.include?(element_name.to_sym)
  end
end
