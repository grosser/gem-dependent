$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rubygems/dependent/version"

Gem::Specification.new "gem-dependent", Gem::Dependent::VERSION do |s|
  s.summary = "See which gems depend on your gems"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{s.name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
