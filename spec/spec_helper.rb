# -*- encoding: utf-8 -*-

require 'bundler'
require 'rspec'
require 'resque'
require 'resque-logger'
require 'logger'

RSpec.configure do |config|
  # spec/support files
  Dir[File.join File.dirname(__FILE__), 'support', '**', '*.rb'].each { |f| require f }
end

