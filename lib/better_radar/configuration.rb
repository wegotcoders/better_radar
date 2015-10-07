class BetterRadar::Configuration

  attr_accessor :feed_name, :delete_after_transfer, :username, :key, :language

  def initialize
    @feed_name = "Fixtures"
    @delete_after_transfer = false
    @language = "BET"
  end
end
