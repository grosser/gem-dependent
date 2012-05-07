# normal require does not work once gem is installed, because its loaded via rubygems
$LOAD_PATH.unshift File.expand_path('..', File.dirname(__FILE__))
require 'lib/rubygems/dependent'

describe Gem::Dependent do
  before do
    Gem::SpecFetcher.fetcher = nil # reset cache
  end

  let(:fixture){ YAML.load(File.read('spec/fixtures/gemcutter_specs.yml')) }
  let(:hoe_gems){
    [
      ["_", ["hoe"]],
      ["1234567890_", ["hoe"]],
      ["actionmailer-javamail", ["hoe"]],
      ["ActiveExcel", ["hoe"]],
      ["activefacts", ["hoe"]],
      ["activeldap", ["hoe"]],
      ["active_mac", ["hoe"]],
      ["activemdb", ["hoe"]],
      ["activerdf_rules", ["hoe"]],
      ["activerecord-jdbc-adapter", ["hoe"]]
    ]
  }

  def simplify(dependencies)
    dependencies.map{|name, deps| [name, deps.map{|d| d.name}] }
  end

  def stub_source(gem_source = nil)
    gem_source ||= 'http://gemcutter.org'
    Gem::SpecFetcher.fetcher.should_receive(:load_specs).with(URI.parse(gem_source), 'specs').and_return(fixture)
    Gem.sources = [gem_source]
  end

  it 'finds dependencies for given gem' do
    stub_source
    dependencies = simplify(Gem::Dependent.find('hoe'))
    dependencies.should == hoe_gems
  end

  it "obeys fetch-limit" do
    stub_source
    dependencies = simplify(Gem::Dependent.find('hoe', :fetch_limit => 100))
    dependencies.should == hoe_gems.first(3)
  end

  it "can use given source" do
    source = 'http://rubygems.org'
    stub_source(source)
    Gem::Dependent.find('hoe', :source => source)
  end

  it "obeys parallel option" do
    stub_source
    Gem::Dependent::Parallel.should_receive(:map).with(anything, :in_processes => 3).and_return []
    Gem::Dependent.find('hoe', :parallel => 3)
  end

  it "has a VERSION" do
    Gem::Dependent::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end
