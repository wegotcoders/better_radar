class BetterRadar::Client
  URL = "https://www.betradar.com/betradar/getXmlFeed.php"

  attr_accessor :feed_name, :user, :key, :options

  def initialize(feed_name, bookmaker, key, options = {})
    self.feed_name = feed_name
    self.user = bookmaker
    self.key = key

    self.options = options
  end

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
      bookmakerName: self.user,
      xmlFeedName: self.feed_name,
      key: self.key
    }
    args.merge!(options)
  end

end
