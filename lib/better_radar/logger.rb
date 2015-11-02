class BetterRadar::Logger

  attr_accessor :file_name, :directory_path, :logger

  def initialize
    @file_name = BetterRadar::configuration.log_filename
    @directory_path = BetterRadar::configuration.log_path
  end

  def check_path
    unless File.directory?(@directory_path)
      FileUtils.mkpath @directory_path
    end
    false
  end

  def write(message)
    unless @logger
      check_path
      file = File.open("#{@directory_path}/#{@file_name}", 'a')
    end
    @logger ||= Logger.new(file)
    @logger.info(message)
    @logger.close
  end

  def directory_path=(path)
    @directory_path = path
    check_path
  end
end
