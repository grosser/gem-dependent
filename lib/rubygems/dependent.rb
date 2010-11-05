require 'parallel'
require 'rubygems/spec_fetcher'

# older parallel versions can produce strange bugs
puts "update parallel gem" if Parallel::VERSION < '0.5.1'

module Gem
  class Dependent
    VERSION = File.read( File.join(File.dirname(__FILE__),'..','..','VERSION') ).strip

    def self.find(gem, options={})
      # get all gems
      specs_and_sources = with_changed_gem_source(options[:source]) do
        all_specs_and_sources
      end

      if options[:fetch_limit]
        specs_and_sources = specs_and_sources.first(options[:fetch_limit])
      end

      if options[:progress]
        puts "Downloading specs for #{specs_and_sources.size} gems"
      end

      gems_and_dependencies = fetch_all_dependencies(specs_and_sources) do
        print_dot if options[:progress]
      end
      print "\n" if options[:progress]

      select_dependent(gems_and_dependencies, gem)
    end

    private

    def self.fetch_all_dependencies(specs_and_sources)
      Parallel.map(specs_and_sources, :in_processes => 15) do |spec, source|
        yield if block_given?
        name = spec.first
        dependencies = fetch_dependencies(spec, source)
        [name, dependencies]
      end
    end

    def self.fetch_dependencies(spec, source)
      begin
        fetcher = Gem::SpecFetcher.fetcher
        fetcher.fetch_spec(spec, URI.parse(source)).dependencies
      rescue Object => e
        $stderr.puts e
        []
      end
    end

    def self.select_dependent(gems_and_dependencies, gem)
      gems_and_dependencies.map do |name, dependencies|
        matching_dependencies = dependencies.select{|d| d.name == gem }
        next if matching_dependencies.empty?
        [name, matching_dependencies]
      end.compact
    end

    def self.print_dot
      print '.'
      $stdout.flush if rand(20) == 0 # make progress visible
    end

    def self.all_specs_and_sources
      fetcher = Gem::SpecFetcher.fetcher
      all = true
      matching_platform = false
      prerelease = false
      matcher = Gem::Dependency.new(//, Gem::Requirement.default) # any name, any version
      specs_and_sources = fetcher.find_matching matcher, all, matching_platform, prerelease
      uniq_by(specs_and_sources){|a| a.first.first } 
    end

    # get unique elements from an array (last found is used)
    # http://drawohara.com/post/146659159/ruby-enumerable-uniq-by
    def self.uniq_by(array, &block)
      uniq = {}
      array.each_with_index do |val, idx|
        key = block.call(val)
        uniq[key] = [idx, val]
      end
      values = uniq.values
      values.sort!{|a,b| a.first <=> b.first}
      values.map!{|pair| pair.last}
      values
    end

    def self.with_changed_gem_source(sources)
      sources = [*sources].compact
      if sources.empty?
        yield
      else
        begin
          old = Gem.sources
          Gem.sources = sources
          yield
        ensure
          Gem.sources = old
        end
      end
    end
  end
end