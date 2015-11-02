module BetterRadar
  VERSION = "0.0.1"

  # These need to be in the module but should this file just be the version number?
  attr_accessor :config

  def self.configure
    yield(self.configuration)
  end

  def self.logger
    @logger ||= BetterRAdar::Logger.new
  end

  def self.configuration
    @config ||= BetterRadar::Configuration.new
  end

  def self.reset
    @config = BetterRadar::Configuration.new
  end
end
