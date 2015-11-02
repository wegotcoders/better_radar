class BetterRadar::Configuration

  attr_accessor :feed_name, :delete_after_transfer, :username, :key, :language

  def initialize
    @feed_name = "Fixtures"
    @delete_after_transfer = false
    @language = "BET"
    @log_filename = "parser.log"
    @log_path = "#{Rails.root}/log/better_radar"
  end
end
