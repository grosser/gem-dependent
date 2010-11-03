require 'rubygems/command'

class Gem::Commands::Dependent < Gem::Command
  def initialize
    super 'dependent', 'Show which gems are depend on a gem'
  end

  def arguments
    "GEMNAME       which gems depend on this gem"
  end

  def usage
    "#{program_name} GEMNAME"
  end

  def execute
    puts 'it works !?'
  end
end