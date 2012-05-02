# -*- encoding: utf-8 -*-

module Resque
  module Plugins
    autoload :Logger,     'resque/plugins/logger'

    module Logger
      autoload :Factory,  'resque/plugins/logger/factory'
    end
  end
end

