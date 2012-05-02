# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "resque_logger/version"

Gem::Specification.new do |s|
  s.name        = "resque-logger"
  s.version     = ResqueLogger::VERSION
  s.authors     = ["Marcelo Correia Pinheiro"]
  s.email       = ["salizzar@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A Resque plugin to provides logger for each worker}
  s.description = %q{A simple mechanism to create custom log files based on queue names of Resque workers.}

  s.rubyforge_project = "resque-logger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency  'rake'
  s.add_development_dependency  'rspec'
  s.add_runtime_dependency      'resque'
end
