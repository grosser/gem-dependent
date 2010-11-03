require 'rubygems/command'

class Gem::Commands::DependentCommand < Gem::Command
  def initialize
    super 'dependent', 'Show which gems depend on a gem'
  end

  def arguments
    "GEMNAME       which gems depend on a gem"
  end

  def usage
    "#{program_name} GEMNAME"
  end

  def execute
    puts "it works #{get_all_gem_names} !?"
  end
end