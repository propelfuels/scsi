module SCSI

  class Config

    # Load Ruby config file
    # @param path [String] config file
    def self.load_config(path)
      raise 'config file missing' unless path
      SCSI.logger.debug("Loading config file: #{path}")
      require File.expand_path(path)
      SCSI.logger.info('Config.load_config done.')
    end

    # Returns the shared instance
    # @return [SCSI::Config]
    def self.shared
      @shared_config ||= Config.new
    end

    # Call this from your config file
    def self.setup
      yield Config.shared
      SCSI.logger.debug('Config.setup block executed.')
    end

    attr_accessor :tokens
    attr_accessor :dump_errors
    attr_accessor :logging

    def initialize
      @tokens = []
      @dump_errors = false
      @logging = false
    end

  end

end
