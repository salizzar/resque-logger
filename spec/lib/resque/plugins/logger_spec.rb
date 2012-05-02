# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Resque::Plugins::Logger do
  include Resque::Plugins::Logger

  @queue = :an_queue

  let(:a_logger) { double 'an mock' }

  it 'returns a instance created by a logger factory' do
    Resque::Plugins::Logger::Factory.should_receive(:get).with(@queue).and_return(a_logger)
    logger.should == a_logger
  end
end

