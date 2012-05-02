# -*- encoding: utf-8 -*-

module RSpecMacros
  def self.included(spec)
    spec.let(:config) do
      {
        folder:     '/path/to/your/log/folder',
        class_name: Logger,
        class_args: [ 'daily', 1024 ],
        level:      Logger::INFO,
        formatter:  Logger::Formatter.new,
      }
    end
  end
end

