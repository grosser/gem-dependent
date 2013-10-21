# normal require does not work once gem is installed, because its loaded via rubygems
$LOAD_PATH.unshift File.expand_path('..', File.dirname(__FILE__))
require 'lib/rubygems/dependent'

describe Gem::Dependent do
  before do
    Gem::SpecFetcher.fetcher = nil # reset cache
  end

  let(:fixture){ YAML.load(File.read('spec/fixtures/gemcutter_specs.yml')) }
  let(:hoe_gems){
    if RUBY_VERSION > "2"
      [
        ["ActiveExcel", ["hoe"]],
        ["_", ["hoe"]],
        ["actionmailer-javamail", ["hoe"]],
        ["active_mac", ["hoe"]],
        ["activefacts", ["hoe"]],
        ["activeldap", ["hoe"]],
        ["activemdb", ["hoe"]],
        ["activerdf_rules", ["hoe"]],
        ["activerecord-jdbc-adapter", ["hoe"]]
      ]
    else
      [
        ["_", ["hoe"]],
        ["actionmailer-javamail", ["hoe"]],
        ["ActiveExcel", ["hoe"]],
        ["activefacts", ["hoe"]], ["activeldap", ["hoe"]],
        ["active_mac", ["hoe"]],
        ["activemdb", ["hoe"]],
        ["activerdf_rules", ["hoe"]],
        ["activerecord-jdbc-adapter", ["hoe"]]
      ]
    end
  }

  def simplify_gem_results(dependencies)
    dependencies.map{|name, version, deps| [name, deps.map{|d| d.name}] }
  end

  def stub_source(options={})
    gem_source = options[:source] || 'http://gemcutter.org'
    if !options[:live]
      fetcher = Gem::SpecFetcher.fetcher
      if RUBY_VERSION > "2"
        fixture = Gem::NameTuple.from_list(fixture())
        fetcher.should_receive(:tuples_for).with { |source, type| source.uri == URI.parse(gem_source) && type == :latest }.and_return(fixture)
      else
        fetcher.should_receive(:load_specs).with(URI.parse(gem_source), 'specs').and_return(fixture())
      end
    end
    Gem.sources = [gem_source]
  end

  it 'finds dependencies for given gem' do
    stub_source
    dependencies = simplify_gem_results(Gem::Dependent.find('hoe'))
    dependencies.should == hoe_gems
  end

  it "obeys fetch-limit" do
    stub_source
    dependencies = simplify_gem_results(Gem::Dependent.find('hoe', :fetch_limit => 100))
    dependencies.should == hoe_gems.first(Gem::VERSION >= "2" ? 3 : 2)
  end

  it "can use given source" do
    source = 'http://rubygems.org'
    stub_source(:source => source)
    Gem::Dependent.find('hoe', :source => source)
  end

  it "obeys parallel option" do
    stub_source
    Gem::Dependent::Parallel.should_receive(:map).with(anything, :in_processes => 3).and_return []
    Gem::Dependent.find('hoe', :parallel => 3)
  end

  it "obeys all versions option" do
    stub_source :live => true
    Gem::Dependent.should_receive(:all_specs_and_sources).with(:all_versions => true)
    Gem::Dependent.find('hoe', :all_versions => true)
  end

  it "obeys type option" do
    stub_source
    Gem::Dependent.should_receive(:select_dependent).with(anything, anything, hash_including(:type => :runtime))
    Gem::Dependent.find('hoe', :type => :runtime)
  end
  it "has a VERSION" do
    Gem::Dependent::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
