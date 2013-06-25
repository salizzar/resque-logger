# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ResqueLogger do
  include RSpecMacros

  describe 'checking configured values' do
    it 'raises an error if folder is not found' do
      config.delete :folder

      error = ArgumentError.new 'Folder must be supplied'

      expect { Resque.logger_config = config }.to raise_error(error.class, error.message)
    end

    it 'raises an error if class name is not found' do
      config.delete :class_name

      error = ArgumentError.new 'Logger must be supplied'

      expect { Resque.logger_config = config }.to raise_error(error.class, error.message)
    end

    it 'not raises otherwise' do
      expect { Resque.logger_config = config }.to_not raise_error
    end

    it 'does not collide with the Resque.logger namespace' do
      Resque.logger_config = config
      expect { Resque.logger.info("Test message") }.to_not raise_error
    end
  end
end

