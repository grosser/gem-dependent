$LOAD_PATH.unshift 'lib'
require 'rubygems/dependent'

describe Gem::Dependent do
  it 'finds dependencies for autotest' do
    expected = [["3scale-3scale_ws_api", "hpricot"], ["3scale-3scale_ws_api_for_ruby", "hpricot"]]
    dependencies = Gem::Dependent.find('hpricot', :fetch_limit => 10)
    dependencies.map{|name, deps| [name, deps.first.name] }.should == expected
  end

  it "has a VERSION" do
    Gem::Dependent::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end