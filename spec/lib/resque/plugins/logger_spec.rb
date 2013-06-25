# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Resque::Plugins::Logger do
  before do
    @worker_queue = :worker_queue

    class ResqueWorker
      extend Resque::Plugins::Logger

      @queue = @worker_queue

      def self.perform(args = {})
        logger.info 'It works!'
      end
    end
  end

  let(:file_path)     { File.join config[:folder], "#{@worker_queue}.log" }
  let(:logger_mock)   { mock Logger }

  let(:config) do
    {
      folder:     '/path/to/your/log/folder',
      class_name: Logger,
      class_args: [ 'daily', 1024 ],
      level:      Logger::INFO,
      formatter:  Logger::Formatter.new,
    }
  end

  before :each do
    Resque.stub(:logger_config).and_return(config)
    logger_mock.should_receive(:info).any_number_of_times

    # FIXME: find a better way to test
    ResqueWorker.instance_variable_set '@logger', nil
    ResqueWorker.instance_variable_set(:@queue, @worker_queue)
  end

  describe 'getting a logger based on queue' do
    before :each do
      config.delete :level
      config.delete :formatter
    end

    it 'creates a logger based on configuration' do
      Logger.should_receive(:new).with(file_path, config[:class_args].first, config[:class_args].last).and_return(logger_mock)

      ResqueWorker.perform
    end

    it 'returns a previously created logger' do
      Logger.stub(:new).and_return(logger_mock)
      ResqueWorker.perform

      Logger.should_not_receive(:new)
      ResqueWorker.perform
    end

    it 'accepts a logger without additional args' do
      config.delete :class_args

      Logger.should_receive(:new).with(file_path).and_return(logger_mock)

      ResqueWorker.perform
    end
  end

  describe 'log file auto-naming' do
    before(:each) do
      config.delete :class_args
      config.delete :level
      config.delete :formatter
    end

    context 'class instance variable is set' do
      before(:each) do
        ResqueWorker.instance_variable_set(:@queue, "custom_queue")
        @file_path = File.join config[:folder], "custom_queue.log"
      end
      after(:each) do
        ResqueWorker.instance_variable_set(:@queue, @worker_queue)
      end

      it 'uses the correct log name' do
        Logger.should_receive(:new).with(@file_path).and_return(logger_mock)

        ResqueWorker.perform
      end
    end

    context 'class queue method exists' do
      before(:each) do
        ResqueWorker.instance_variable_set(:@queue, nil)
        ResqueWorker.class_eval do
          def self.queue
            "another_queue"
          end
        end
        @file_path = File.join config[:folder], "another_queue.log"
      end
      after(:each) do
        ResqueWorker.class_eval do
          class << self
            remove_method :queue
          end
        end
      end

      it 'uses the correct log name' do
        Logger.should_receive(:new).with(@file_path).and_return(logger_mock)

        ResqueWorker.perform
      end
    end

    context 'no queue name is specified' do
      before do
        ResqueWorker.instance_variable_set(:@queue, nil)
        Resque.queue_from_class(ResqueWorker).should be_false
      end
      it 'uses a default log name' do
        default_file_path = File.join(config[:folder], Resque::Plugins::Logger::DEFAULT_LOG_NAME)
        Logger.should_receive(:new).with(default_file_path).and_return(logger_mock)

        ResqueWorker.perform
      end
    end
  end

  describe 'explicitly setting the log name' do
    before(:each) do
      @base = "hey_a_log_file.log"
      @file_path = File.join config[:folder], @base
      ResqueWorker.instance_variable_set("@log_name", @base)
      config.delete :level
      config.delete :formatter
    end
    after(:each) do
      ResqueWorker.instance_variable_set("@log_name", nil)
    end

    it 'uses the log_name method' do
      config.delete :class_args
      Logger.should_receive(:new).with(@file_path).and_return(logger_mock)

      ResqueWorker.perform
    end
  end

  describe 'setting logger options from configuration' do
    before :each do
      Logger.stub(:new).and_return(logger_mock)
    end

    it 'configures logger level if informed' do
      config.delete :formatter

      logger_mock.should_receive(:level=).with(config[:level])

      ResqueWorker.perform
    end

    it 'configures logger formatter if informed' do
      config.delete :level

      logger_mock.should_receive(:formatter=).with(config[:formatter])

      ResqueWorker.perform
    end

    it 'not configures level and formatter if not exists' do
      config.delete :level
      config.delete :formatter

      logger_mock.should_not_receive(:level=)
      logger_mock.should_not_receive(:formatter=)

      ResqueWorker.perform
    end
  end
end

