# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Resque::Plugins::Logger::Factory do
  include RSpecMacros

  let(:subject)     { Resque::Plugins::Logger::Factory }

  let(:logger)      { double Logger }
  let(:queue)       { :an_queue }
  let(:file_path)   { File.join config[:folder], "#{queue}.log" }

  before :each do
    Resque.stub(:logger).and_return(config)
  end

  describe 'creating a logger given a queue' do
    before :each do
      config.delete :level
      config.delete :formatter
    end

    it 'returns a new instance of configured logger if not exists' do
      Logger.should_receive(:new).with(file_path, config[:class_args].first, config[:class_args].last).and_return(logger)

      subject.get(queue).should == logger
    end

    it 'returns previous created logger if exists' do
      Logger.should_not_receive(:new)

      subject.get queue
    end
  end

  describe 'setting configurations' do
    before :each do
      Logger.should_receive(:new).and_return(logger)
    end

    it 'configures level if exists' do
      config.delete :formatter

      logger.should_receive(:level=).with(config[:level])

      subject.get :a_queue_with_level
    end

    it 'configures formatter if exists' do
      config.delete :level

      logger.should_receive(:formatter=).with(config[:formatter])

      subject.get :a_queue_with_formatter
    end

    it 'not assigns level and formatter if not exists' do
      config.delete :level
      config.delete :formatter

      logger.should_not_receive(:level=)
      logger.should_not_receive(:formatter=)

      subject.get :a_basic_queue_config
    end
  end
end

