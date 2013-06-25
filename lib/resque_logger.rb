# -*- encoding: utf-8 -*-

require "resque_logger/version"
require "resque/setup"

module ResqueLogger
  module ClassMethods
    def logger_config
      @logger_config
    end

    #
    # Configures ResqueLogger with the following hash:
    # {
    #   folder: <folder location for logs>,
    #   class_name: <class name to be created>,
    #   class_args: <an array of class arguments to be passed in constructor>,
    #   level: <logger level>,
    #   formatter: <a new instance of formatter class to add in logger>
    # }
    #
    # Hash keys will be symbols to work.
    #
    def logger_config=(options)
      check_logger_args! options

      @logger_config = options
    end

    private

    #
    # Check for necessary keys and raises if not found.
    #
    def check_logger_args!(options)
      keys = options.keys

      raise ArgumentError.new 'Folder must be supplied' unless keys.include?(:folder)
      raise ArgumentError.new 'Logger must be supplied' unless keys.include?(:class_name)
    end
  end
end

Resque.extend ResqueLogger::ClassMethods

