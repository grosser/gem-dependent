module Gem::Dependent::ProgressFormatters

  class Dot < Gem::Dependent::ProgressFormatter
    def on_init(session)
      puts "Downloading specs for #{session[:count]} gems"
    end

    def on_download(gem)
      print "."
    end

    def on_complete
      puts
    end
  end

end