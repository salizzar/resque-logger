# -*- encoding: utf-8 -*-

module Resque
  module Plugins
    module Logger
      #
      # Returns a logger instance based on queue name.
      #
      def logger
        Resque::Plugins::Logger::Factory.get @queue
      end
    end
  end
end

