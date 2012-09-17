module Gem::Dependent::ProgressFormatters

  class Percentage < Gem::Dependent::ProgressFormatter
    def percent_complete
      '%.2f' % ((@complete.to_f/@count.to_f)*100.0)
    end

    def on_init(session)
      @count = session[:count]
      @complete = 0
      
      puts "Downloading specs for #{@count} gems"
    end
    
    def on_download(gem)
      @complete += 1

      print "#{percent_complete}%   \r"
    end
  end

end