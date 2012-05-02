# -*- encoding: utf-8 -*-

module Resque
  module Plugins
    module Logger
      class Factory
        @queue_map = {}

        #
        # Returns a new instance of configured logger given a queue name.
        # If queue logger is already created, returns previous instance.
        #
        def self.get(queue)
          queue_name = queue.to_sym
          logger = @queue_map[queue_name]

          if logger.nil?
            logger = create_logger queue_name
            @queue_map[queue_name] = logger
          end

          logger
        end

        private

        #
        # Creates a new instance of logger given a queue name, retrieving
        # configuration from Resque.logger.
        #
        def self.create_logger(queue)
          config = Resque.logger
          log_path = config[:folder]
          class_name = config[:class_name]
          class_args = config[:class_args]

          file_path = File.join log_path, "#{queue}.log"

          logger = class_name.new file_path, *class_args
          logger.level = config[:level] if config[:level]
          logger.formatter = config[:formatter] if config[:formatter]

          logger
        end
      end
    end
  end
end

