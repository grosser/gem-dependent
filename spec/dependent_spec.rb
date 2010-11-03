$LOAD_PATH.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'lib/rubygems/dependent' # normal require does not work once gem is installed, wtf...

describe Gem::Dependent do
  before do
    Gem::SpecFetcher.fetcher = nil # reset cache
  end

  let(:fixture){ YAML.load(File.read('spec/fixtures/gemcutter_specs.yml')) }
  let(:hoe_gems){
    [
      ["7digital", ["hoe"]],
      ["abingo_port", ["hoe"]],
      ["abundance", ["hoe"]],
      ["actionview-data", ["hoe"]],
      ["active_link_to", ["hoe"]],
      ["activemerchant-paymentech-orbital", ["hoe"]],
      ["active_nomad", ["hoe"]],
      ["active_presenter", ["hoe"]],
      ["activerecord-fast-import", ["hoe"]],
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
    dependencies.should == hoe_gems.first(4)
  end

  it "can use given source" do
    source = 'http://rubygems.org'
    stub_source(source)
    Gem::Dependent.find('hoe', :source => source)
  end

  it "has a VERSION" do
    Gem::Dependent::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end