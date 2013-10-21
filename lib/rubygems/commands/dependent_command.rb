require 'rubygems/command'

class Gem::Commands::DependentCommand < Gem::Command
  def initialize
    super 'dependent', 'Show which gems depend on a gem', :progress => true

    add_option('--source URL', 'Query these sources (e.g. http://gemcutter.org)') do |n, _|
      options[:source] = n.to_s.split(',')
    end

    add_option('--no-progress', 'Do not show progress') do
      options[:progress] = false
    end

    add_option('--fetch-limit N', Integer, 'Fetch specs for max N gems (for fast debugging)') do |n, _|
      options[:fetch_limit] = n
    end

    add_option('--parallel N', Integer, 'Make N requests in parallel (default 15)') do |n, _|
      options[:parallel] = n
    end

    add_option('--all-versions', 'Check against all versions of gems') do
      options[:all_versions] = true
    end

    add_option('--type dependent_type', 'Only look for dependents matching the listed type(s) (default is runtime and development)') do |n, _|
      options[:type] = n.to_s.split(',').map(&:to_sym)
    end
  end

  def arguments
    "GEMNAME       which gems depend on a gem"
  end

  def usage
    "#{program_name} GEMNAME"
  end

  def execute
    # only require when it is really needed, otherwise
    # it would be required every time someone loads rubygems
    require 'rubygems/dependent'

    gem = get_all_gem_names.first
    gems_and_dependencies = Gem::Dependent.find(gem, options)
    gems_and_dependencies.each do |gem, version, dependencies|
      requirements = dependencies.map do |dependency|
        formatted_dependency(dependency)
      end.join(', ')
      version = (options[:all_versions] ? " (v#{version})" : "")
      puts "#{gem}#{version} #{requirements}"
    end
  rescue Object => e
    $stderr.puts e
    $stderr.puts e.backtrace
  end

  private

  def formatted_dependency(dependency)
    type = " (#{dependency.type})" if dependency.type == :development
    "#{dependency.requirement}#{type}"
  end
end
