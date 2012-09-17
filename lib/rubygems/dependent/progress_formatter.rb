require 'active_support/core_ext/string/inflections'

module Gem::Dependent
  # A namespace to define all progress formatters
  module ProgressFormatters; end
  
  class ProgressFormatter
    # NOTE: Can't decide on `on_init`, `on_begin`, `on_start`, etc.. `on_init` seems to be the most popular for event-style classes.

    class NotFound < StandardError
      def to_s
        available_formatters = ProgressFormatter.all.keys.sort
        
        "\nFormatter not found\nAvailable formatters: #{available_formatters.join(', ')}\n\n"
      end
    end

    class << self

      # An Array containing all immediate children of Gem::Dependent::Formatter
      attr :all

      # Add any immediate children of Gem::Dependent::Formatter to an Hash that
      # we can easily access by using Gem::Dependent::Formatter.all
      # 
      # The key is the name of the child as a formatted Symbol and the value is
      # the child
      def inherited(child)
        (@all ||= {})[ child.to_s.demodulize.underscore.to_sym ] = child
      end

      # Find a child Class of Gem::Dependent::ProgressFormatter by it's formatted Symbol
      def find(child_name)
        result = @all[child_name]
        
        raise NotFound unless result
        
        result
      end

    end

    def print(*args)
      $stderr.print(*args)
      # flush
    end

    def puts(*args)
      $stderr.puts(*args)
      # flush
    end

    # Make progress visible
    def flush
      $stderr.flush if rand(20) == 0
    end
  end

end

# Load all formatters
Dir[ File.join( File.expand_path(File.dirname(__FILE__)), 'progress_formatters', '*') ].each { |filename| require filename }