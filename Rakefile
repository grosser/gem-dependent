task :default => :spec
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--backtrace --color'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'gem-dependent'
    gem.summary = "See which gems depend on your gems"
    gem.email = "grosser.michael@gmail.com"
    gem.homepage = "http://github.com/grosser/#{gem.name}"
    gem.authors = ["Michael Grosser"]


    # if parallel was a dependency, every requirement of rubygems would
    # load parallel, which causes overhead and problems
    gem.post_install_message = <<-POST_INSTALL_MESSAGE
#{'*'*50}

Since parallel cannot be a dependency, please install by hand:

gem install parallel

#{'*'*50}
POST_INSTALL_MESSAGE
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: gem install jeweler"
end
