class BetterRadar::Client
  URL = "https://www.betradar.com/betradar/getXmlFeed.php"

  def get_xml_feed
    Tempfile.open('better_radar', Dir.tmpdir, 'w') do |f|
      f.write open(build_url).string
      f
    end
  end

  private

  def build_url
    generated_url = URL << "?"
    feed_arguments.each_with_index do |(key, value), index|
      generated_url << "#{key}=#{value}"
      generated_url << "&" unless index == feed_arguments.length - 1
    end
    generated_url
  end

  def feed_arguments
    args = {
      bookmakerName: BetterRadar.configuration.username,
      xmlFeedName: BetterRadar.configuration.feed_name,
      key: BetterRadar.configuration.key,
      deleteAfterTransfer: url_friendly(:deleteAfterTransfer)
    }
  end

  def url_friendly(variable)

    case variable
    when :deleteAfterTransfer
      BetterRadar.configuration.delete_after_transfer ? "yes" : "no"
    end
  end

end
