# -*- encoding: utf-8 -*-

module Resque
  module Plugins
    module Logger
      #
      # Returns a logger instance based on queue name.
      #
      def logger
        @logger ||= create_logger
      end

      private
      #
      # Creates a new instance of logger given a queue name, retrieving
      # configuration from Resque.logger.
      #
      def create_logger
        config = Resque.logger_config
        log_path = config[:folder]
        class_name = config[:class_name]
        class_args = config[:class_args]

        file_basename = @log_name || "#{@queue}.log"
        file_path = File.join log_path, file_basename

        logger = class_name.new file_path, *class_args
        logger.level = config[:level] if config[:level]
        logger.formatter = config[:formatter] if config[:formatter]

        logger
      end
    end
  end
end

