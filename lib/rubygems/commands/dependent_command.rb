require 'rubygems/command'
require 'rubygems/dependent'

class Gem::Commands::DependentCommand < Gem::Command
  def initialize
    super 'dependent', 'Show which gems depend on a gem'

    add_option('--fetch-limit N', Integer, 'Fetch specs for max N gems (for fast debugging)') do |limit, _|
      options[:fetch_limit] = limit
    end
  end

  def arguments
    "GEMNAME       which gems depend on a gem"
  end

  def usage
    "#{program_name} GEMNAME"
  end

  def execute
    gem = get_all_gem_names.first
    gems_and_dependencies = Gem::Dependent.find(gem, options)
    gems_and_dependencies.each do |gem, dependencies|
      requirements = dependencies.map do |dependency|
        formatted_dependency(dependency)
      end.join(', ')
      puts "#{gem} #{requirements}"
    end
  end

  private

  def formatted_dependency(dependency)
    type = " (#{dependency.type})" if dependency.type == :development
    "#{dependency.requirement}#{type}"
  end
end