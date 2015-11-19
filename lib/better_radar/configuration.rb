class BetterRadar::Configuration

  attr_accessor :feed_name, :delete_after_transfer, :username, :key, :language, :log_filename, :log_path, :only_recent

  def initialize
    @feed_name = "Fixtures"
    @delete_after_transfer = false
    @language = "BET"
    @log_filename = "parser.log"
    @log_path = "#{Rails.root}/log/better_radar"
    @only_recent = false
  end
end
