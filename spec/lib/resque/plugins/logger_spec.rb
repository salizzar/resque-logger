# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Resque::Plugins::Logger do
  @worker_queue = :worker_queue

  class ResqueWorker
    extend Resque::Plugins::Logger

    @queue = @worker_queue

    def self.perform(args = {})
      logger.info 'It works!'
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

