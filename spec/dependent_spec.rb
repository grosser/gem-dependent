$LOAD_PATH.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'lib/rubygems/dependent' # normal require does not work once gem is installed, wtf...

describe Gem::Dependent do
  before do
    Gem.stub!(:sources).and_return ['http://gemcutter.org']
  end

  it 'finds dependencies for autotest' do
    gem_source = URI.parse('http://gemcutter.org')
    fixture = YAML.load(File.read('spec/fixtures/gemcutter_specs.yml'))
    Gem::SpecFetcher.fetcher.should_receive(:load_specs).with(gem_source, 'specs').and_return(fixture)

    expected = [["7digital", ["hoe"]], ["abingo_port", ["hoe"]], ["abundance", ["hoe"]], ["actionview-data", ["hoe"]]]
    dependencies = Gem::Dependent.find('hoe', :fetch_limit => 100)
    dependencies.map{|name, deps| [name, deps.map{|d| d.name}] }.should == expected
  end

  it "has a VERSION" do
    Gem::Dependent::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end