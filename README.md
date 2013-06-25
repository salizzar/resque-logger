Resque Per-worker Logger Plugin
===============================

Tired of create mechanisms to isolate log files to each [Resque][] worker in your application?
The gem resque-logger gives you a simple plugin to create a log file based on queue name.

Configuration
=============

### Using a initializer
    # config/initializers/resque.rb

    log_path = File.join Rails.root, 'log'

    config = {
      folder:     log_path,                 # destination folder
      class_name: Logger,                   # logger class name
      class_args: [ 'daily', 1.kilobyte ],  # logger additional parameters
      level:      Logger::INFO,             # optional
      formatter:  Logger::Formatter.new,    # optional
    }

    Resque.logger_config = config

Usage
=====

### Adding to a resque worker
    # app/workers/my_killer_worker.rb

    class MyKillerWorker
      extend Resque::Plugins::Logger

      @queue = :my_killer_worker_job
      @log_name = "my_killer_log_name.log" # Optional - defaults to using the queue name.

      def self.perform(args = {})
        (...)

        logger.info('it works!')

        (...)
      end
    end

Dependencies
============

* resque

Installation
============

### With rubygems:
    $ [sudo] gem install resque-logger

Authors
=======

* Marcelo Correia Pinheiro - <http://salizzar.net/>

License
=======

ResqueLogger is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.

[Resque]: https://github.com/defunkt/resque

